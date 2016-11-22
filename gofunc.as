#module gofunc
	#define global funcArea if 0
	//命令・関数呼び出し
	#define global call funcall
	#define global ctype funcall(%1, \
		%2="null",%3="null",%4="null",%5="null",%6="null",%7="null",%8="null",%9="null",%10="null",%11="null") \
		(call_gofunc@gofunc(%1, \
		""+%2+"$ParamS$"+%3+"$ParamS$"+%4+"$ParamS$"+%5+"$ParamS$"+%6+"$ParamS$"+%7+"$ParamS$"+%8+"$ParamS$"+%9+"$ParamS$"+%10+"$ParamS$"+%11))
	#define global subcall(%1, \
		%2="null",%3="null",%4="null",%5="null",%6="null",%7="null",%8="null",%9="null",%10="null",%11="null") \
		%tfunc %i=%1:%i%o0=call_gofunc@gofunc(%o, \
		""+%2+"$ParamS$"+%3+"$ParamS$"+%4+"$ParamS$"+%5+"$ParamS$"+%6+"$ParamS$"+%7+"$ParamS$"+%8+"$ParamS$"+%9+"$ParamS$"+%10+"$ParamS$"+%11)
	#defcfunc local call_gofunc var flabel,str pAll
		paramStr@gofunc=pAll
		gosub flabel
	return result

	//関数定義
	#define global ctype fn(%1) Function_%1
	#define global ctype def(%1, \
		%2=nul@gofunc,%3=nul@gofunc,%4=nul@gofunc,%5=nul@gofunc,%6=nul@gofunc, \
		%7=nul@gofunc,%8=nul@gofunc,%9=nul@gofunc,%10=nul@gofunc,%11=nul@gofunc) \
		%tgofuncdef%i0 \
		*%1: split paramStr@gofunc,"$ParamS$",%2,%3,%4,%5,%6,%7,%8,%9,%10,%11
	#define global resolve(%1) result@gofunc=%1:return
	#define global endef %tgofuncdef%o0 return

	//型変換
	#define global ints(%1=nul@gofunc,%2=nul@gofunc,%3=nul@gofunc,%4=nul@gofunc,%5=nul@gofunc, \
						%6=nul@gofunc,%7=nul@gofunc,%8=nul@gofunc,%9=nul@gofunc,%10=nul@gofunc) \
		ints@gofunc %1,%2,%3,%4,%5,%6,%7,%8,%9,%10
	#deffunc local ints var p1,var p2,var p3,var p4,var p5,var p6,var p7,var p8,var p9,var p10
		p1=int(p1):p2=int(p2):p3=int(p5):p4=int(p4):p5=int(p5)
		p6=int(p6):p7=int(p7):p8=int(p8):p9=int(p9):p10=int(p10)
	return

	#define global doubles(%1=nul@gofunc,%2=nul@gofunc,%3=nul@gofunc,%4=nul@gofunc,%5=nul@gofunc, \
							%6=nul@gofunc,%7=nul@gofunc,%8=nul@gofunc,%9=nul@gofunc,%10=nul@gofunc) \
		doubles@gofunc %1,%2,%3,%4,%5,%6,%7,%8,%9,%10
	#deffunc doubles var p1,var p2,var p3,var p4,var p5,var p6,var p7,var p8,var p9,var p10
		p1=double(p1):p2=double(p2):p3=double(p5):p4=double(p4):p5=double(p5)
		p6=double(p6):p7=double(p7):p8=double(p8):p9=double(p9):p10=double(p10)
	return

	//配列変換
	#defcfunc zipArray array arr
		typeInt=vartype(arr(0))
		if		typeInt=2{	type="$StrArraY$"}
		else:if typeInt=3{	type="$DoubleArraY$"}
		else:if typeInt=4{	type="$IntArraY$"}
		else:				mes "zipArray error": return 0

		arrStr=type
		foreach arr
			if cnt!=0:arrStr+="$ArraY$"
			arrStr+=str(arr(cnt))
		loop
	return arrStr

	#deffunc unzipArray str _arrstr,array arr
		arrstr=_arrstr
		if 0<=instr(arrstr,,"$StrArraY$") {
			split arrstr,"$StrArraY$",nul,arrstr
			split arrstr,"$ArraY$",arr
		}
		else:if 0<=instr(arrstr,,"$DoubleArraY$") {
			split arrstr,"$DoubleArraY$",nul,arrstr
			split arrstr,"$ArraY$",_arr
			ddim arr,length(_arr)
			foreach _arr
				arr(cnt)=double(_arr(cnt))
			loop
		}
		else:if 0<=instr(arrstr,,"$IntArraY$") {
			split arrstr,"$IntArraY$",nul,arrstr
			split arrstr,"$ArraY$",_arr
			dim arr,length(_arr)
			foreach _arr
				arr(cnt)=int(_arr(cnt))
			loop
		}
		else {
			arr=_arrstr
		}
	return

	#define global pushArray(%1,%2) %tpushArray %i=%2: pushArray_gofunc@gofunc %1,%o
	#deffunc local pushArray_gofunc array arr,var addItem
		typeInt=vartype(addItem)
		IsNullArray=arr(0)="[]"
		if IsNullArray: arrLength=1: else: arrLength=length(arr)+1

		copyArray arr,_arr
		type2ArrayCast typeInt,arr,addItem,length(arr)-1
		if IsNullArray {
			arr=addItem
			return
		}
		foreach _arr
			arr(cnt)=_arr(cnt)
		loop
		arr(length(arr))=addItem
	return

	#define global unshiftArray(%1,%2) %tunshiftArray %i=%2: unshiftArray_gofunc@gofunc %1,%o
	#deffunc local unshiftArray_gofunc array arr,var addItem
		typeInt=vartype(addItem)
		IsNullArray=arr(0)="[]"
		if IsNullArray: arrLength=1: else: arrLength=length(arr)+1

		copyArray arr,_arr
		type2ArrayCast typeInt,arr,addItem,arrLength
		if IsNullArray {
			arr=addItem
			return
		}
		foreach _arr
			arr(cnt+1)=_arr(cnt)
		loop
		arr(0)=addItem
	return

	#define global popArray(%1,%2=nul@gofunc) popArray@gofunc %1,%2
	#deffunc local popArray array arr,var removeItem
		if length(arr)=1 {
			arr="[]"
			return
		}
		copyArray arr,_arr
		typeInt=vartype(arr(0))
		removeItem=arr(length(arr)-1)
		type2ArrayCast typeInt,arr,nul,length(arr)-1
		foreach arr
			arr(cnt)=_arr(cnt)
		loop
	return

	#define global shiftArray(%1,%2=nul@gofunc) shiftArray@gofunc %1,%2
	#deffunc local shiftArray array arr,var removeItem
		if length(arr)=1 {
			arr="[]"
			return
		}
		copyArray arr,_arr
		typeInt=vartype(arr(0))
		removeItem=arr(0)
		type2ArrayCast typeInt,arr,nul,length(arr)-1
		foreach arr
			arr(cnt)=_arr(cnt+1)
		loop
	return

	#deffunc addRange array arr1,array arr2
		if arr1="[]" :copyArray arr2,arr1: return
		if arr2="[]" :return
		typeInt=vartype(arr1(0))
		if typeInt!=vartype(arr2(0)): mes "型が異なるためaddRangeできません": return
		mergeLength=length(arr1)+length(arr2)
		copyArray arr1,_arr1
		type2ArrayCast typeInt,arr1,nul,mergeLength
		foreach _arr1
			arr1(cnt)=_arr1(cnt)
		loop
		foreach arr2
			arr1(length(_arr1)+cnt)=arr2(cnt)
		loop
	return

	#deffunc local type2ArrayCast int _typeInt,array arr,var castItem,int _arrLength
		if _typeInt=2 {	
			sdim arr,,_arrLength
		}
		else:if _typeInt=3 {
			ddim arr,_arrLength
			castItem=double(castItem)
		}
		else:if _typeInt=4 {
			dim arr,_arrLength
			castItem=int(castItem)
		}
		else {
			mes "type2ArrayCast error"
		}
	return

	#deffunc copyArray array arr1,array arr2
		typeInt=vartype(arr1(0))
		if		typeInt=2{	sdim arr2,,length(arr1)}
		else:if typeInt=3{	ddim arr2,length(arr1)}
		else:if typeInt=4{	dim arr2,length(arr1)}
		else:				mes "popArray error": return
		foreach arr1
			arr2(cnt)=arr1(cnt)
		loop
	return

	#define global ctype joinStr(%1,%2=",") joinStr_gofunc@gofunc(%1,%2)
	#defcfunc local joinStr_gofunc array arr,str _deli
		arrStr=""
		foreach arr
			if cnt!=0:arrStr+=_deli
			arrStr+=str(arr(cnt))
		loop
	return arrStr
#global
