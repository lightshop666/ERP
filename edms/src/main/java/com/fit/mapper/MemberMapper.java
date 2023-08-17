package com.fit.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.MemberFile;
import com.fit.vo.MemberInfo;

@Mapper
public interface MemberMapper {
	// 인사정보 등록여부 검사
	int empInfoCnt(int empNo);
		
	// 사원번호 중복검사
	int memberInfoCnt(int empNo);
	
	// 회원가입
	int addMember(MemberInfo memberInfo);
	
	// 개인정보 조회 // emp_name 추출을 위해 emp_info와 join해야하므로 반환타입은 Map
	Map<String, Object> selectMemberInfo(int empNo);
	
	// 개인정보 파일 조회
	MemberFile selectMemberFile(int empNo, String fileCategory);
}
