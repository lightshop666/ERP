package com.fit.websocket;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.fit.vo.Alarm;

@Service
public class WSService {
	
	private final SimpMessagingTemplate messagingTemplate;
	
	// 이 서비스 클래스는 웹 소켓 관련 비즈니스 로직을 처리
	// 여기에서는 SimpMessagingTemplate를 사용하여 웹 소켓 메시지를 보내고 NotificationService를 사용하여 알림 메시지를 처리
	
	@Autowired
	public WSService(SimpMessagingTemplate messagingTemplate) {
		this.messagingTemplate = messagingTemplate;
	}
	
	// 클라이언트에게 일반 메시지를 전송
	public void notifyFrontend(final String message) {
	    // ResponseMessage 객체를 생성하고, 메시지 내용을 설정
	    ResponseMessage response = new ResponseMessage(message);
	    	
	    // '/topic/messages' 주제로 메시지를 전송하여 모든 연결된 클라이언트에게 브로드캐스트합니다.
	    messagingTemplate.convertAndSend("/topic/messages", response);
	}
	
	// 특정 사용자에게 개인 메시지 전송
	public void notifyUser(final String id, final String message) {
	    // ResponseMessage 객체를 생성하고, 메시지 내용을 설정
	    ResponseMessage response = new ResponseMessage(message);
	
	    // '/topic/privateMessages' 주제로 메시지를 전송하여 해당 사용자에게 개인 메시지 전송
	    messagingTemplate.convertAndSendToUser(id, "/topic/privateMessages", response);
	}
	
}