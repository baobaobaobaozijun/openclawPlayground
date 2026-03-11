#!/usr/bin/env node
/**
 * Inbox Poller for OpenClaw Agents
 * Monitors the inbox directory for new messages and triggers processing
 */

const fs = require('fs');
const path = require('path');
const { WebSocket } = require('ws');

const CONFIG = {
  inboxDir: process.env.INBOX_DIR || '/app/communication/inbox',
  gatewayUrl: process.env.GATEWAY_WS_URL || 'ws://127.0.0.1:18789',
  pollInterval: parseInt(process.env.POLL_INTERVAL_MS) || 5000,
  agentName: process.env.INSTANCE_NAME || 'unknown'
};

const processedMessages = new Set();

function loadProcessedMessages() {
  const cacheFile = path.join(CONFIG.inboxDir, '.processed.json');
  try {
    if (fs.existsSync(cacheFile)) {
      const data = JSON.parse(fs.readFileSync(cacheFile, 'utf8'));
      data.forEach(id => processedMessages.add(id));
    }
  } catch (e) {
    console.log(`[inbox-poll] Failed to load processed cache: ${e.message}`);
  }
}

function saveProcessedMessages() {
  const cacheFile = path.join(CONFIG.inboxDir, '.processed.json');
  try {
    fs.writeFileSync(cacheFile, JSON.stringify([...processedMessages]), 'utf8');
  } catch (e) {
    console.log(`[inbox-poll] Failed to save processed cache: ${e.message}`);
  }
}

function getInboxPath() {
  return path.join(CONFIG.inboxDir, CONFIG.agentName);
}

function scanInbox() {
  const inboxPath = getInboxPath();
  if (!fs.existsSync(inboxPath)) {
    console.log(`[inbox-poll] Inbox directory not found: ${inboxPath}`);
    return [];
  }

  const files = fs.readdirSync(inboxPath)
    .filter(f => f.endsWith('.json') && !f.startsWith('.'))
    .map(f => {
      const filePath = path.join(inboxPath, f);
      const stat = fs.statSync(filePath);
      return { name: f, path: filePath, mtime: stat.mtimeMs };
    })
    .filter(f => !processedMessages.has(f.name));

  return files;
}

function processMessage(file) {
  console.log(`[inbox-poll] Processing: ${file.name}`);
  
  try {
    const content = fs.readFileSync(file.path, 'utf8');
    const message = JSON.parse(content);
    
    console.log(`[inbox-poll] Message from ${message.from} to ${message.to}: ${message.action}`);
    
    // Mark as processed
    processedMessages.add(file.name);
    saveProcessedMessages();
    
    // Move to processed folder
    const processedDir = path.join(path.dirname(file.path), '..', 'processed', CONFIG.agentName);
    if (!fs.existsSync(processedDir)) {
      fs.mkdirSync(processedDir, { recursive: true });
    }
    const destPath = path.join(processedDir, file.name);
    fs.renameSync(file.path, destPath);
    
    console.log(`[inbox-poll] Moved to processed: ${destPath}`);
    
    return { success: true, message };
  } catch (e) {
    console.error(`[inbox-poll] Error processing ${file.name}: ${e.message}`);
    return { success: false, error: e.message };
  }
}

async function main() {
  console.log(`[inbox-poll] Starting inbox poller for ${CONFIG.agentName}`);
  console.log(`[inbox-poll] Inbox: ${getInboxPath()}`);
  console.log(`[inbox-poll] Poll interval: ${CONFIG.pollInterval}ms`);
  
  loadProcessedMessages();
  console.log(`[inbox-poll] Loaded ${processedMessages.size} processed message IDs from cache`);
  
  setInterval(() => {
    const messages = scanInbox();
    if (messages.length > 0) {
      console.log(`[inbox-poll] Found ${messages.length} new message(s)`);
      messages.forEach(processMessage);
    }
  }, CONFIG.pollInterval);
  
  // Initial scan
  const initialMessages = scanInbox();
  if (initialMessages.length > 0) {
    console.log(`[inbox-poll] Found ${initialMessages.length} message(s) on startup`);
    initialMessages.forEach(processMessage);
  }
}

main().catch(console.error);
