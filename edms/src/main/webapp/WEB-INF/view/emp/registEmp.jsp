<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>registEmp</title>
	<!-- JQuery -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<!-- xls 형식을 파싱하기 위해 SheetJS 라이브러리의 xls 모듈을 사용 -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.9/xlsx.full.min.js"></script>
	<script>
		$(document).ready(function() { // 웹 페이지가 모든 html 요소를 로드한 후에 내부(JQuery)의 코드를 실행하도록 보장
			
			// 취소 버튼 클릭 시
			$('#cancelBtn').click(function() {
				let result = confirm('HOME으로 이동할까요?'); // 사용자 선택 값에 따라 true or false 반환
				if (result) {
					window.location.href = '/home'; // Home으로 이동
				}
			});
		
			// 업로드 버튼 클릭 시
	        $('#uploadBtn').click(function(event) {
	            const fileInput = $('#fileInput');

	            if (fileInput.get(0).files.length === 0) {
	                event.preventDefault(); // 기본 동작 중단
	                alert('파일을 선택해주세요.');
	                return false;
	            }

	            const file = fileInput.get(0).files[0]; // 선택된 파일 가져오기
	            const fileName = file.name;
	            const fileExtension = fileName.split('.').pop().toLowerCase();

	            // 엑셀 파일이 아닌 경우 업로드 막기
	            if (fileExtension !== 'xlsx' && fileExtension !== 'xls') {
	                event.preventDefault(); // 기본 동작 중단
	                alert('엑셀 파일(xlsx 또는 xls)만 선택해주세요.');
	                return false;
	            }
	        });
			
	     	// 페이지 로딩 시 주소창 파라미터 확인 후 알림 표시
	        const urlParams = new URLSearchParams(window.location.search);
	        const failParam = urlParams.get('result'); // '?' 제외한 파라미터 이름만 사용

	        if (failParam == 'fail') { // fail 파라미터 값이 있을 경우에만 알림 표시
	            alert('엑셀 파일 업로드에 실패했습니다. 엑셀 파일을 확인해주세요.');
	        }
			
		});
	</script>
<style>
	/* 구분선 */
	hr {
	    border: solid 3px black;
	    width: 20%;
	    margin: 0; /* auto 가운데 정렬 */
	}
	/* 테이블 중앙 정렬 */
	table {
		text-align: center;
	}
</style>
</head>
<body>
	<h3>사원 등록</h3>
	
	<!-- 엑셀 공통 양식 다운로드 버튼 추가 -->
	<a href="/file/defaultTemplate.xlsx" download="defaultTemplate.xlsx">엑셀 공통 양식 다운로드</a>
	
	<!-- 파일 업로드 -->
	<form id="uploadForm" action="/excelUpload" method="post" enctype="multipart/form-data">
		<input type="file" name="file" id="fileInput">
		<button type="submit" id="uploadBtn">저장</button>
		<span id="msg"></span>
	</form>
	
	<!-- 사원 정보 등록 -->
	<form action="/emp/registEmp" method="post"><!-- 성공 시 사원목록 페이지로 -->
		<!-- 재직과, 남은휴가일수는 고정되어있으므로 hidden 타입으로 제출 -->
		<input type="hidden" name="empState" value="재직">
		<input type="hidden" name="remainDays" value="0.0">
		
		<table border="1">
			<tr>
				<td>사원번호</td>
				<td><input type="number" name="empNo" value="${empNo}"></td><!-- 직접 입력 / 사원번호 랜덤 생성 후 자동 입력 -->
				<td><button type="button">사원번호 생성</button></td>
			</tr>
			<tr>
				<td>사원명</td>
				<td colspan="2"><input type="text" name="empName"></td>
			</tr>
			<tr>
				<td>부서명</td>
				<td colspan="2">
					<select name="deptName">
						<option value="" <c:if test="${emp.deptName.equals('')}">selected</c:if>>없음</option>
						<c:forEach var="d" items="${deptList}">
							<option value="${d.deptName}" <c:if test="${emp.deptName.equals(d.deptName)}">selected</c:if>>${d.deptName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td>팀명</td>
				<td colspan="2">
					<select name="teamName">
						<option value="" <c:if test="${emp.teamName.equals('')}">selected</c:if>>없음</option>
						<c:forEach var="t" items="${teamList}">
							<option value="${t.teamName}" <c:if test="${emp.teamName.equals(t.teamName)}">selected</c:if>>${t.teamName}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
			    <td>직급</td>
			    <td colspan="2">
			        <select name="empPosition">
						<option value="CEO" <c:if test="${emp.empPosition.equals('CEO')}">selected</c:if>>CEO</option>
						<option value="부서장" <c:if test="${emp.empPosition.equals('부서장')}">selected</c:if>>부서장</option>
						<option value="팀장" <c:if test="${emp.empPosition.equals('팀장')}">selected</c:if>>팀장</option>
						<option value="부팀장" <c:if test="${emp.empPosition.equals('부팀장')}">selected</c:if>>부팀장</option>
						<option value="사원" <c:if test="${emp.empPosition.equals('사원')}">selected</c:if>>사원</option>
					</select>
			    </td>
			</tr>
			<tr>
			    <td>권한</td>
			    <td colspan="2">
			        <select name="accessLevel">
						<option value="0" <c:if test="${emp.accessLevel.equals('0')}">selected</c:if>>0레벨</option>
						<option value="1" <c:if test="${emp.accessLevel.equals('1')}">selected</c:if>>1레벨</option>
						<option value="2" <c:if test="${emp.accessLevel.equals('2')}">selected</c:if>>2레벨</option>
						<option value="3" <c:if test="${emp.accessLevel.equals('3')}">selected</c:if>>3레벨</option>
					</select>
			    </td>
			</tr>
			<tr>
				<td>입사일</td>
				<td colspan="2">
					<input type="date" name="employDate">
				</td>
			</tr>
		</table>
		
		<br>
		<hr><!-- 구분선 -->
		<br>
		
		<button type="button" id="cancelBtn">취소</button><!-- 좌정렬 예정 -->
		<button type="submit" id="saveBtn">등록</button><!-- 우정렬 예정 -->
	</form>
</body>
</html>