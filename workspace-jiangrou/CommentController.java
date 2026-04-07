package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * 评论管理 API 控制器
 */
@RestController
@RequestMapping("/api/comments")
public class CommentController {

    @GetMapping
    public List<Comment> getComments(@RequestParam(required = false) Long articleId) {
        // 获取文章评论列表
        // 实际实现需要注入Service和Repository
        return null;
    }

    @PostMapping
    public Comment createComment(@RequestBody Comment comment) {
        // 创建评论
        // 实际实现需要注入Service和Repository
        return null;
    }

    @DeleteMapping("/{id}")
    public void deleteComment(@PathVariable Long id) {
        // 删除评论
        // 实际实现需要注入Service和Repository
    }
}

class Comment {
    private Long id;
    private Long articleId;
    private String content;
    private String author;
    private Long createTime;

    // getter和setter方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getArticleId() { return articleId; }
    public void setArticleId(Long articleId) { this.articleId = articleId; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    
    public Long getCreateTime() { return createTime; }
    public void setCreateTime(Long createTime) { this.createTime = createTime; }
}