--[[
msg					--控制台输出，参数string
init 				--(失效)初始屏幕方向，参数0=home下1=home右2=home左
mSleep				--延迟，参数int毫秒
touchDown			--按下，参数1 index，参数2 x，参数3 y
touchUp				--弹起，参数1 index，参数2 x，参数3 y
touchMove			--移动，参数1 index，参数2 x，参数3 y
keepScreen			--(失效)保持屏幕，参数bool，true保持后需要设置false才会释放
switchAccount		--（失效）切换帐号获取屏幕，参数bool，需要false才会释放
findColor			--多点较色，参数1 table{X1,Y1,X2,Y2}，参数2 string 颜色，参数3 simi 相识度
getpm				--获取屏幕图片
dofile 				--导入lua文件
getHeight			--获取屏幕高
getWidth			--获取屏幕宽
getInt 				--获取配置int类型数据，参数string，配置的名称，返回值，int
getSwitch			--获取配置Switch bool类型数据，参数string，配置的名称，返回值，bool
getMission			--获取任务顺序，参数无，返回值table，key：123，value：string
findMultiColor		--多点较色返回全部坐标，参数1 table{X1,Y1,X2,Y2}，参数2 string 颜色，参数3 simi 相识度，返回值string：x,y|x,y
getOrien			--更新屏幕方向
removeMission		--（失效）移除任务，参数一name，参数二key
inputText			--输入文本，参数string
ocrText				--ocr光学识别文本，参数1 table{x1,y1,x2,y2}，参数2 string 白名单，参数3 min 0-255，参数4 max 0-255 返回值string
setString			--保存一个文本，参数str
getString			--获取保存的文本，返回值，str
LoadSNS 			--读取加密lua文件，参数str
]]--

function delay(s)
 	local rans = s + math.random(-200,200);
 	mSleep(rans);
end


function click(x,y)
	getOrien();
	local ranx = x + math.random(-5,5);
	local rany = y + math.random(-5,5);
	local s = math.random(50,200);
	touchDown(1,ranx,rany);
	mSleep(s);
	touchUp(1,ranx,rany);
end

function move(orien,x,y,dis)--0向下拉，1向上拉，2向右拉，3向左拉
	getOrien();
	local ranx = x + math.random(-10,10);
	local rany = y + math.random(-10,10);
	local s = math.random(50,200);
	touchDown(1,ranx,rany);
	mSleep(s);
	if orien==0 then
	 	while rany<=y+dis do
	 		ranx = ranx + math.random(-5,5);
	 		rany = rany + math.random(20,30);
	 		s = math.random(20,50);
	 		touchMove(1,ranx,rany);
	 		mSleep(s);
	 	end
	elseif orien==1 then
	 	while rany>=y-dis do
	 		ranx = ranx + math.random(-5,5);
	 		rany = rany - math.random(20,30);
	 		s = math.random(20,50);
	 		touchMove(1,ranx,rany);
	 		mSleep(s);
	 	end
	elseif orien==2 then
	 	while ranx<=x+dis do
	 		ranx = ranx + math.random(20,30);
	 		rany = rany + math.random(-5,5);
	 		s = math.random(20,50);
	 		touchMove(1,ranx,rany);
	 		mSleep(s);
	 	end
	elseif orien==3 then
	 	while ranx>=x-dis do
	 		ranx = ranx - math.random(20,30);
	 		rany = rany + math.random(-5,5);
	 		s = math.random(20,50);
	 		touchMove(1,ranx,rany);
	 		mSleep(s);
	 	end
	end
	touchUp(1,ranx,rany);
end

function Split(szFullString, szSeparator)--分割函数
	local nFindStartIndex = 1  
	local nSplitIndex = 1  
	local nSplitArray = {}  
	while true do  
	   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
	   if not nFindLastIndex then  
	   		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
	    	break  
	   end  
	   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
	   nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
	   nSplitIndex = nSplitIndex + 1  
	end  
	return nSplitArray  
end

function findPointFuzzy(x,y,colorStr)--单点较色
	local x,y = findColor({x-5,y-5,x+5,y+5},colorStr,0.9)
	if x~=-1 then
		return true;
	else
		return false;
	end
end

function guolv(str,value,lx)--过滤函数，参数1str：x,y|x,y|x,y参数2过滤值参数3过滤类型xy,x,y
	local tableValue = {};
	local max = 0;
	if str == "" then
		return tableValue;
	end
	local tableStr = Split(str,"|");
	for i=1,#tableStr do
		tableValue[i] = Split(tableStr[i],",");
	end
	for i=1,#tableValue do
		for n=i+1,#tableValue do
			if lx == "xy" then
				max = ((tableValue[i][1] - tableValue[n][1])^2 + (tableValue[i][2] - tableValue[n][2])^2)^0.5;
			elseif lx == "x" then
				max = math.abs(tableValue[i][1] - tableValue[n][1]);
			elseif lx == "y" then
				max = math.abs(tableValue[i][2] - tableValue[n][2]);
			end
			if max < value then
				tableValue[n][1] = -1000;
				tableValue[n][2] = -1000;
			end
		end
	end
	for i=#tableValue,1,-1 do
		if tableValue[i][1] == -1000 then
			table.remove(tableValue,i);
		end
	end
	return tableValue;
end

function findNumber(tableRange,tableNumber,value)--查找数字，参数1范围，参数2数字组{{color,mis},{color,mis}}，参数3过滤值，返回值str
	local text = "";
	--过滤数字组
	local tableColor = {};
	local tableSort = 0;
	for i=1,#tableNumber do
		local str = "";
		for n=1,#tableNumber[i] do
			local colorStr = findMultiColor(tableRange,tableNumber[i][n][1],tableNumber[i][n][2]);
			if colorStr ~= "" then
				if str == "" then
					str = colorStr;
				else
					str = str.."|"..colorStr;
				end
			end
		end
		if str ~= "" then
			tableSort = tableSort + 1;
			tableColor[tableSort] = {n="",table=""};
			tableColor[tableSort].n = i - 1;
			tableColor[tableSort].table = guolv(str, value, "x");
		end
	end
	if tableSort==0 then
		return text;
	end
	if tableSort==1 then
		for i=1,#tableColor[1].table do
			text = text..tableColor[1].n;
		end
		return text;
	end
	--排序
	if tableSort>1 then
		--整理成table可以处理的
		local allretnumber={};
		local num = 0;	
		for i=1,#tableColor do
			for n=1,#tableColor[i].table do
				num = num + 1;
				allretnumber[num]={x="",y="",n=""}
				allretnumber[num].x=tableColor[i].table[n][1];
				allretnumber[num].y=tableColor[i].table[n][2];
				allretnumber[num].n=tableColor[i].n;
			end
		end
		table.sort(allretnumber,function(a,b) return a.x<b.x end );
		for i=1,#allretnumber do
			text = text..allretnumber[i].n;
		end
	end
	return text;
end

function findArrayColor(range,tableColor)--查找数组颜色，参数1范围，参数2color=table[1][1]mis=table[1][2],返回x,y
	local x=-1
	local y=-1;
	for i=1,#tableColor do
		x,y = findColor(range,tableColor[i][1],tableColor[i][2]);
		if x~=-1 then
			-- msg(tostring(i));
			-- delay(1000);
			break;
		end
	end
	return x,y;
end