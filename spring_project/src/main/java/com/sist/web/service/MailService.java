package com.sist.web.service;

import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.sist.web.controller.MailController;
import com.sist.web.dao.EmailDao;
import com.sist.web.model.Email;

@Service("mailService")
public class MailService {

	@Autowired
	private JavaMailSender mailSender;
	/*
	 * @Autowired private SimpleMailMessage preConfiguredMessage;
	 */
	
	@Autowired
	private EmailDao emailDao;
	
	private static Logger logger = LoggerFactory.getLogger(MailService.class);
	
	@Async
	public void sendMail(String to , String subject, String body)
	{
		MimeMessage message = mailSender.createMimeMessage();
		
		try {
			MimeMessageHelper messageHelper = new MimeMessageHelper(message,true,"UTF-8"); 
			
			//메일 수신 시 표시될 이름 설정
			messageHelper.setFrom("springProject@naver.com","진수성찬");
			messageHelper.setSubject(subject);
			messageHelper.setTo(to);
			messageHelper.setText(body, true);
			mailSender.send(message);
			
		} catch (Exception e) 
		{
			e.printStackTrace();
		}
		
	}
	
	// 이메일 인증코드 삽입
	public int emailInsert (Email eamil) {
		int count = 0;
		
		try {
			count = emailDao.emailInsert(eamil);
		} catch (Exception e) {
			logger.error("[MailService] emailInsert SQLExcpetion", e);
		}
	
		return count;
	}
	
	// 이메일 인증코드 조회
	public String emailSelect (String userEmail) {
		String code = "";
		
		try {
			code = emailDao.emailSelect(userEmail);
		} catch (Exception e) {
			logger.error("[MailService] emailSelect SQLExcpetion", e);
		}
		
		return code;
	}
	
	// 이메일 인증코드 삭제
	public int emailDelete (String userEmail) {
		int count = 0;
		
		try {
			count = emailDao.emailDelete(userEmail);
		} catch (Exception e) {
			logger.error("[MailService] emailSelect SQLExcpetion", e);
		}
		
		return count;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
