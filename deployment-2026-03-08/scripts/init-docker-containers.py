#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
OpenClaw Docker 容器初始化脚本
功能：检查 Docker 环境、启动容器、验证服务状态
"""

import subprocess
import sys
import time
from pathlib import Path

class Colors:
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    CYAN = '\033[96m'
    RESET = '\033[0m'

def print_header(text):
    print(f"\n{Colors.CYAN}{'='*60}{Colors.RESET}")
    print(f"{Colors.CYAN}{text:^60}{Colors.RESET}")
    print(f"{Colors.CYAN}{'='*60}{Colors.RESET}\n")

def print_success(text):
    print(f"{Colors.GREEN}✅ {text}{Colors.RESET}")

def print_warning(text):
    print(f"{Colors.YELLOW}⚠️  {text}{Colors.RESET}")

def print_error(text):
    print(f"{Colors.RED}❌ {text}{Colors.RESET}")

def check_docker():
    """检查 Docker 是否安装并运行"""
    try:
        result = subprocess.run(['docker', '--version'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print_success(f"Docker 已安装：{result.stdout.strip()}")
            return True
        else:
            print_error("Docker 未正常运行")
            return False
    except Exception as e:
        print_error(f"检查 Docker 失败：{e}")
        return False

def check_docker_compose():
    """检查 Docker Compose 是否安装"""
    try:
        result = subprocess.run(['docker-compose', '--version'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print_success(f"Docker Compose 已安装：{result.stdout.strip()}")
            return True
        else:
            print_warning("Docker Compose 可能未正确安装")
            return False
    except Exception as e:
        print_error(f"检查 Docker Compose 失败：{e}")
        return False

def start_containers(compose_file):
    """使用 Docker Compose 启动容器"""
    print_header(f"启动容器：{compose_file}")
    
    if not Path(compose_file).exists():
        print_error(f"配置文件不存在：{compose_file}")
        return False
    
    try:
        # 停止现有容器
        print("正在停止现有容器...")
        subprocess.run(['docker-compose', '-f', compose_file, 'down'], 
                      check=False)
        
        # 启动新容器
        print("正在启动新容器...")
        result = subprocess.run(['docker-compose', '-f', compose_file, 'up', '-d'], 
                              check=True, capture_output=True, text=True)
        
        print_success("容器启动成功！")
        return True
    except subprocess.CalledProcessError as e:
        print_error(f"启动容器失败：{e}")
        return False
    except Exception as e:
        print_error(f"启动容器时发生错误：{e}")
        return False

def check_container_status(container_name):
    """检查容器运行状态"""
    try:
        result = subprocess.run(['docker', 'ps', '--filter', f'name={container_name}', 
                              '--format', '{{.Status}}'], 
                              capture_output=True, text=True, timeout=10)
        if result.stdout.strip():
            print_success(f"{container_name}: {result.stdout.strip()}")
            return True
        else:
            print_warning(f"{container_name} 未运行")
            return False
    except Exception as e:
        print_error(f"检查 {container_name} 状态失败：{e}")
        return False

def verify_services():
    """验证所有服务是否正常运行"""
    print_header("验证服务状态")
    
    containers = [
        'openclaw-instance-1',
        'openclaw-instance-2',
        'openclaw-instance-3',
        'searxng-jiangrou',
        'searxng-dousha',
        'searxng-suancai'
    ]
    
    all_running = True
    for container in containers:
        if not check_container_status(container):
            all_running = False
    
    return all_running

def show_access_info():
    """显示访问信息"""
    print_header("访问信息")
    
    info = """
OpenClaw Agent UI:
  酱肉 (Jiangrou): http://localhost:18791
  豆沙 (Dousha):   http://localhost:18792
  酸菜 (Suancai):  http://localhost:18793

SearXNG 搜索引擎:
  酱肉的技术调研：http://localhost:8081
  豆沙的设计资源：http://localhost:8082
  酸菜的运维知识：http://localhost:8083

Token 获取方式:
  docker exec <容器名> openclaw dashboard --no-open
"""
    print(info)

def main():
    """主函数"""
    print_header("OpenClaw Docker 容器初始化工具")
    
    # 检查环境
    print("检查 Docker 环境...")
    docker_ok = check_docker()
    compose_ok = check_docker_compose()
    
    if not docker_ok:
        print_error("请先安装并启动 Docker Desktop")
        sys.exit(1)
    
    # 启动容器
    agents_ok = start_containers('docker-compose-agents.yml')
    searxng_ok = start_containers('docker-compose-searxng.yml')
    
    # 等待容器启动
    print("\n等待容器启动...")
    time.sleep(10)
    
    # 验证服务
    services_ok = verify_services()
    
    # 显示访问信息
    if services_ok:
        show_access_info()
        print_success("所有服务已就绪！")
    else:
        print_warning("部分服务未正常启动，请检查日志")
    
    return 0 if services_ok else 1

if __name__ == '__main__':
    sys.exit(main())
