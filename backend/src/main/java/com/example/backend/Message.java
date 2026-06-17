package com.example.backend;

import lombok.Data;

@Data
public class Message {
    private String from;
    private String content;
    private String timestamp;
}
