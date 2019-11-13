dofile("main1.lua");--导入基本函数库
dofile("iPhone6.lua");
--导入配置文件
local screenHeight = getHeight();
local screenWidth = getWidth();
local screenRange = { 0, 0, screenWidth, screenHeight};
local screenPoint = {screenWidth-5,screenHeight-5};--空白点

function main()
	-- msg(tostring(getInt("913")*10))
	-- delay(3000);

	welfare();
	local m = 0
	local xunhuan = getInt("917") + 1
	while m < xunhuan do
		m = m + 1
		xunhuan = getInt("917") + 1
		if getSwitch("900") then
			gameScreen();
			mainMission();
		end
		if getSwitch("502") then
			gameScreen();
			hongchen();
		end
		local missionTable = getMission();
		local sort = 0;
		if #missionTable ~= 0 then
			sort = #missionTable;
		end
		local i = 0
		while i<sort do
			missionTable = getMission();
			sort = #missionTable;
			i = i+1
			if getSwitch("901") and (missionTable[i] == "师" or #missionTable==0) then
				gameScreen();
				shimen();
			end
			if getSwitch("902") and (missionTable[i] == "鬼" or #missionTable==0) then
				gameScreen();
				zhuagui();
			end
			if getSwitch("903") and (missionTable[i] == "打" or #missionTable==0) then
				gameScreen();
				dabaotu();
			end
			if getSwitch("904") and (missionTable[i] == "挖" or #missionTable==0) then
				gameScreen();
				wabaotu();
			end
			if getSwitch("905") and (missionTable[i] == "封" or #missionTable==0) then
				gameScreen();
				fengyao();
			end
			if getSwitch("906") and (missionTable[i] == "普" or #missionTable==0) then
				gameScreen();
				putongyabiao();
			end
			if getSwitch("907") and (missionTable[i] == "高" or #missionTable==0) then
				gameScreen();
				gaojiyabiao();
			end
			if getSwitch("908") and (missionTable[i] == "答" or #missionTable==0) then
				gameScreen();
				dati();
			end
			if getSwitch("909") and (missionTable[i] == "副" or #missionTable==0) then
				gameScreen();
				fuben();
			end
			if getSwitch("910") and (missionTable[i] == "秘" or #missionTable==0) then
				gameScreen();
				mijing();
			end
			if getSwitch("911") and (missionTable[i] == "环" or #missionTable==0) then
				gameScreen();
				paohuan();
			end
			if getSwitch("912") and (missionTable[i] == "帮" or #missionTable==0) then
				gameScreen();
				bangpai();
			end
		end--for sort
		if getSwitch("500") then
			pinghuo();
		end
	end
end


function fengyao()
	msg("封妖任务开始");
	delay(1000);
	--找活动图标
	--找封妖活动
	--点击参加
	--判断主界面
	--打开小地图
	--找到放大镜
	--找到关闭按钮
	--找远古


end

function zhuagui()
	msg("抓鬼任务开始");
	delay(1000);



end

function putongyabiao()
	msg("普通押镖开始");
	delay(1000);



end

function gaojiyabiao()
	msg("高级押镖开始");
	delay(1000);



end

function dati()
	msg("随机答题开始");
	delay(1000);



end

function mijing()
	msg("秘境任务开始");
	delay(1000);



end

function fuben()
	fuben1();
	fuben2();
end

function fuben1()
	msg("50级副本开始");
	delay(1000);



end

function fuben2()
	msg("70级副本开始");
	delay(1000);



end

function paohuan()
	msg("跑环任务开始");
	delay(1000);



end

function bangpai()
	msg("帮派任务开始");
	delay(1000);



end

function pinghuo()
	msg("接取平定安邦");
	delay(1000);

	msg("领取活跃");
	delay(1000);

end

function clear()
	if getSwitch("501") then
		msg("清理背包");
		delay(1000);


		msg("清理完成");
		delay(1000);
	end
end

function welfare()
	if getSwitch("503") then
		gameScreen();
		msg("领取每日福利");
		delay(1000);


		msg("领取完成");
		delay(1000);
	end
end

function hongchen()
	msg("红尘试练开始");
	delay(1000);
	mission(hongchenshilian,3);
	msg("红尘试练完成");
	delay(1000);
end

function mainMission()
	msg("主线任务开始");
	delay(1000);
	mission(zhuxianrenwu,2);
	msg("主线任务完成");
	delay(1000);
end

function wabaotu()
	msg("挖宝图任务开始");
	delay(1000);
	while true do
		gameScreen();
		getpm();
		local x,y = findColor(screenRange,
			 baonang[1],baonang[2])--包囊图标
		if x~=-1 then
			msg("打开包囊");
			click(x, y);
			delay(1000);
		end
		click(wpanPoint[1],wpanPoint[2]);--点击物品
		delay(1000);
		click(zlanPoint[1],zlanPoint[2]);--整理包囊
		delay(1000);
		local m = 0;
		while m<5 do
			getpm();
			local x,y = findColor(screenRange,
				 cangbaotu[1],cangbaotu[2])--宝图
			if x~=-1 then
				msg("找到宝图");
				click(x, y);
				delay(1000);
				break;
			else
				m=m+1;
				delay(500);
			end
		end
		if m==5 then
			close();
			break;
		end
		getpm();
		local x,y = findColor(supply_syanRange, 
			syan[1],syan[2])--使用按钮
		if x~=-1 then
			msg("使用藏宝图");
			click(x, y);
			delay(1000);
		end
		local i=0;
		while i<20 do
			getpm();
			local x,y = findColor(syan_range, 
				syan[1],syan[2])--使用按钮
			if x~=-1 then
				msg("使用物品");
				click(x, y);
				delay(3000);
				i=0;
			else
				fighting();
				i=i+1;
				msg("当前任务等待："..tostring(i));
				delay(1000);
			end	
		end
	end
	msg("藏宝图已经挖完");
	delay(1000);
end

function dabaotu()
	msg("打宝任务");
	delay(1000);
	getpm();
	local x,y = findArrayColor(missionRange,baotuMission_colorMis)--打宝任务
	if x==-1 then
		local m=0;
		while m<5 do
			gameScreen();
			click(dadituPoint[1],dadituPoint[2]);--打开大地图
			delay(1000);
			getpm();
			local x,y = findColor(screenRange,
				 dadituchangancheng[1],dadituchangancheng[2])--大地图长安城
			if x~=-1 then
				click(x, y);
				delay(2000);
			end
			local z = 0;
			while z<5 do
				getpm();
				local x,y = findColor(screenRange,
				 changancheng[1],changancheng[2])--长安城
				if x~=-1 then
					break;
				else
					z=z+1;
					delay(500);
				end
			end
			if z~=5 then
				click(xiaodituPoint[1],xiaodituPoint[2]);--打开小地图
				delay(1000);
				click(dianxiaoerPoint[1],dianxiaoerPoint[2]);--点击店小二
				delay(3000);
				local n=0;
				while n<10 do
					getpm();
					local x,y = findColor(rwdhk_Point, 
							rwdhk_colorMis[1],rwdhk_colorMis[2])--人物对话框
						if x~=-1 then
							local x1,y1 = findColor(dh_Point, 
								dh_colorMis[1],dh_colorMis[2])--对话
							if x1~=-1 then
								msg("对话");
								click(x1, y1);
								delay(1000);
							end
							close();
							break;
						else
							n=n+1;
						end
					delay(1000);
				end
				if n ~= 10 then
					break;
				end
			end
			m=m+1;
		end
		if m==5 then
			msg("不能找到店小二");
			delay(500);
			return;
		end
	end
	while true do
		gameScreen();
		local finish = findMission(baotuMission_colorMis);--宝图任务
		if finish == 0 then
			break;
		end
		local i = 0;
		while i<20 do
			getpm();
			local x1,y1 = findColor(dh_Point, 
				dh_colorMis[1],dh_colorMis[2])--对话
			if x1~=-1 then
				msg("对话");
				click(x1, y1);
				delay(1000);
			end
			local battle = fighting();
			if battle then
				i=0;
			else
				i=i+1;
				msg("当前任务等待："..tostring(i));
				delay(1000);
			end
		end
	end
	msg("打宝任务完成");
	delay(1000);
end

function shimen()
	msg("师门任务");
	delay(1000);
	mission(shimenMission,1);
	msg("师门任务完成");
	delay(1000);
end

function judgeMoney(lx)
	if lx == 1 then--师门
		local numberString = ocrText({541,234,705,273},"0123456789");
		if numberString ~= "" then
			msg("价格:"..numberString);
			delay(1000);
			if tonumber(numberString) > getInt("913")*10 then
				ReMission();
			end
		end
	end
end

function ReMission()
	msg("重接任务");
	delay(1000);
end

function mission(colorStr,lx)
	local zhuxian = 0;
	local zhuxiantuichu = 0;
	local zhandou = false;
	while true do
		if lx == 2 or lx == 3 then
			if not zhandou then
				zhuxian = 0;
			end
			getpm();
			local x,y = findColor(screenRange, 
				zhandoushibai[1],zhandoushibai[2])--战斗失败
			if x~=-1 then
				msg("战斗失败");
				click(blankPoint[1], blankPoint[2]);
				delay(1000);
				if zhuxian == getInt("916") then
					return 0;
				end
				zhuxian = zhuxian + 1;
			end
			gameScreen();
			if zhuxiantuichu==3 then
				return 0;
			end
			local finish = findMission(colorStr,lx);
			if finish == 0 then
				return 0;
			end
		else
			gameScreen();
			local finish = findMission(colorStr,lx);
			if finish == 0 then
				return 0;
			end
		end
		local i=0;
		local m=0;
		while i<20 and m<10 do
			getpm();
			local x,y = findColor(gman_Point,
				 gman_colorMis[1],gman_colorMis[2])--购买按钮
			if x~=-1 then
				local x1,y1 = findColor(screenRange,
					 btjm[1],btjm[2])--摆摊界面
				if x1~=-1 then
					judgeMoney(lx);
				end	
				i=0;
				m=m+1;
				zhandou = false;
				msg("购买物品");
				click(x, y);
				delay(1000);
				close();
			end	
			local x,y = findColor(syan_range, 
				syan[1],syan[2])--使用按钮
			if x~=-1 then
				zhandou = false;
				msg("使用物品");
				click(x, y);
				delay(3500);
				getpm();
				local x1,y1 = findColor(rwdhk_Point, 
				 rwdhk_colorMis[1],rwdhk_colorMis[2])--人物对话框
				if x1~=-1 then
					msg("关闭人物对话框");
					click(blankPoint[1],blankPoint[2]);
					delay(1000);
				end
				zhuxiantuichu=0;
				break;
			end	
			local x,y = findColor(sjan_Point,
				 sjan_colorMis[1],sjan_colorMis[2])--上交按钮
			if x~=-1 then
				i=0;
				m=m+1;
				zhandou = false;
				msg("上交物品");
				click(x, y);
				delay(1000);
			end	
			local x,y = findColor(rwdhk_Point, 
				 rwdhk_colorMis[1],rwdhk_colorMis[2])--人物对话框
			if x~=-1 then
				--判断是否有完成任务按钮没有就点击
				local x1,y1 = findColor(dh_Point, 
					dh_colorMis[1],dh_colorMis[2])--对话
				if x1~=-1 then
					i=0;
					m=m+1;
					msg("对话");
					click(x1, y1);
					delay(1000);
				else
					msg("关闭人物对话框");
					click(blankPoint[1],blankPoint[2]);
					delay(1000);
					zhuxiantuichu=0;
					break;--直接点击任务，因为任务已经完成
				end
			end	
			local x,y = findColor(screenRange,
				 choujiang[1],choujiang[2])--抽奖
			if x~=-1 then
				i=0;
				m=m+1;
				msg("抽奖");
				click(x,y);
				delay(3000);
			end	
			local battle = fighting();
			if battle then
				zhandou = true;
				zhuxiantuichu=0;
				break;
			end
			local juqing = dianjijuqing();
			if juqing then
				local x1,y1 = findColor(screenRange, 
					xzcw_colorMis[1],xzcw_colorMis[2])--选择宠物
				if x1~=-1 then
					msg("选择宠物");
					click(x1, y1);
					delay(1000);
					-- buzhua();
				end
				getpm();
				fighting();
				local x1,y1 = findColor(dh_Point, 
					dh_colorMis[1],dh_colorMis[2])--对话
				if x1~=-1 then
					i=0;
					m=m+1;
					msg("对话");
					click(x1, y1);
					delay(1000);
				else
					zhuxiantuichu=0;
					break;
				end
			end
			if lx==2 then
				local guide = findGuide();
				if guide then
					zhuxiantuichu=0;
					break;
				end
			end
			if m==0 and i==0 then
				zhuxiantuichu=zhuxiantuichu+1;
			end
			i=i+1;
			msg("当前任务等待："..tostring(i));
			delay(1000);
		end
	end

end

function dianjijuqing()
	getpm();
	-- local x1,y1 = findColor(screenRange, 
	-- 	djryjx_colorMis[1],djryjx_colorMis[2])--点击继续
	local x2,y2 = findColor(screenRange, 
		djtgjq_colorMis[1],djtgjq_colorMis[2])--点击跳过
	if x2==-1 then
		return false;
	end
	local n = 0;
	while n<5 do
		getpm();
		-- local x1,y1 = findColor(screenRange, 
		-- 	djryjx_colorMis[1],djryjx_colorMis[2])--点击继续
		-- if x1~=-1 then
		-- 	msg("点击继续");
		-- 	click(x1, y1);
		-- 	delay(1000);
		-- end	
		local x2,y2 = findColor(screenRange, 
			djtgjq_colorMis[1],djtgjq_colorMis[2])--点击跳过
		if x2~=-1 then
			n=0;
			msg("跳过剧情");
			click(x2, y2);
			delay(1000);
		else
			n=n+1;
			delay(200);
		end
	end
	return true;
end
--[[
function buzhua()

	local i=0;
	while i<5 do
		getpm();
		local x,y = findColor(fgt_Point, 
			fgt_colorMis[1],fgt_colorMis[2])
		if x~=-1 then
			i=0;
			msg("捕抓宠物");
			delay(1000);
			break;
		else
			i=i+1;
			delay(500);
		end
	end
	local x,y = findColor(screenRange, 
		bzcw_colorMis[1],bzcw_colorMis[2])--点击捕抓
	if x~=-1 then
		click(x, y);
		delay(1000);
		click(zhuguaiPoint[1], zhuguaiPoint[2]);--点击主怪
		delay(1000);
	end
	getpm();
	local x,y = findColor(zdfgt_Point, 
		zdfgt_colorMis[1],zdfgt_colorMis[2])
	if x~=-1 then
		msg("Auto");
		click(x, y);
		delay(3000);
	end


end
]]--
function findMission(missionColor,lx)--lx类型1师门2主线3红尘

	local two = 0;
	while two<5 do
		close();
		getpm();
		local x,y = findColor(screenRange,missionBook[1],missionBook[2]);--任务书
		if x == -1 then
			click(missionBookClick[1],missionBookClick[2]);
			delay(1000);
		end
		-- local x,y = findColor(missionRange,missionColor,simi);--任务范围
		local x,y = findArrayColor(missionRange, missionColor);--任务范围
		if x ~= -1 then
			two = 0;
			msg("找到目标任务");
			click(x, y);
			delay(500);
			return 1;
		else
			if lx==1 or lx==2 or two<2 then
				move(0,missionPointUp[1],missionPointUp[2],missionPointUp[3]);--上找任务
			else
				move(1,missionPointDown[1],missionPointDown[2],missionPointDown[3]);--下找任务
			end
			two = two +1;
			delay(1000);
		end
	end
	msg("没有寻找到目标任务");
	delay(500);
	return 0;
end

function findGuide()
	getpm();
	local x1,x2,y1,y2;
	x1,y1 = findColor(screenRange, 
		ydRight_colorMis[1],ydRight_colorMis[2])--点击引导右下
	x2,y2 = findColor(screenRange, 
		ydLeft_colorMis[1],ydLeft_colorMis[2])--点击引导左上
	if x1==-1 and x2==-1 then
		return false;
	end
	local n = 0;
	while n<5 do
		getpm();
		x2,y2 = findColor(screenRange, 
			ydLeft_colorMis[1],ydLeft_colorMis[2])--点击引导左上
		if x2~=-1 then
			msg("引导");
			click(x2+yd_pianyi[1], y2+yd_pianyi[2]);
			delay(1500);
		else
			x1,y1 = findColor(screenRange, 
				ydRight_colorMis[1],ydRight_colorMis[2])--点击引导右下
			if x1~=-1 then
				msg("引导");
				click(x1-yd_pianyi[1], y1-yd_pianyi[2]);
				delay(1500);
			end
		end
		if x1==-1 and x2==-1 then
			n=n+1;
			delay(200);
		else
			n=0;
		end
	end
	close(true,true);
	msg("引导结束");
	delay(500);
	return true;
end

function fighting()
	getpm();
	local x,y = findColor(fgt_Point, 
			fgt_colorMis[1],fgt_colorMis[2])--战斗标识
	if x==-1 then
		return false;
	end
	local i=0;
	while i<5 do
		getpm();
		local x,y = findColor(fgt_Point, 
			fgt_colorMis[1],fgt_colorMis[2])
		if x~=-1 then
			i=0;
			msg("fighting...");
			delay(1000);
			close(true);
		else
			i=i+1;
			delay(200);
		end
		local x,y = findColor(zdfgt_Point, 
			zdfgt_colorMis[1],zdfgt_colorMis[2])
		if x~=-1 then
			msg("Auto");
			click(x, y);
			delay(1000);
		end
	end
	msg("battle end...");
	delay(500);
	return true;
end


function close(fgt,findG)
	getpm();
	if not findG then
		local guide = findGuide();
		if guide then
			return 1;
		end
	end
	local juqing = dianjijuqing();
	if juqing then
		return 1;
	end
	local x,y = findColor(qxan_Point,
		 qxan_colorMis[1],qxan_colorMis[2])--取消按钮
	if x~=-1 then
		msg("取消");
		click(x, y);
		delay(1000);
		return 1;
	end	
	local x,y = findColor(screenRange,
		 ltzk[1],ltzk[2])--聊天窗口
	if x~=-1 then
		msg("聊天窗口");
		click(x, y);
		delay(1000);
		return 1;
	end	
	local x,y = findColor(screenRange,
		flhx[1],flhx[2])--福利红叉
	if x~=-1 then
		welfare();
		msg("关闭福利红叉");
		click(x, y);
		delay(1000);
		return 1;
	end
	local x,y = findColor(screenRange,
		bnhx[1],bnhx[2])--包裹红叉
	if x~=-1 then
		msg("关闭包囊红叉");
		click(x, y);
		delay(1000);
		return 1;
	end
	local x,y = findColor(screenRange,
		qyhx[1],qyhx[2])--奇遇红叉
	if x~=-1 then
		msg("关闭奇遇红叉");
		click(x, y);
		delay(1000);
		return 1;
	end
	local x,y = findColor(screenRange,
		xszkhx[1],xszkhx[2])--限时折扣红叉
	if x~=-1 then
		msg("关闭限时折扣红叉");
		click(x, y);
		delay(1000);
		return 1;
	end
	local x,y = findColor(screenRange,
		hfhx[1],hfhx[2])--工坊红叉
	if x~=-1 then
		msg("关闭工坊红叉");
		click(x, y);
		delay(1000);
		return 1;
	end
	local x,y = findColor(screenRange,
		ddthx[1],ddthx[2])--大地图红叉
	if x~=-1 then
		msg("关闭大地图红叉");
		click(x, y);
		delay(1000);
		return 1;
	end
	local x,y = findColor(rwdhk_Point, 
		rwdhk_colorMis[1],rwdhk_colorMis[2])--人物对话框
	if x~=-1 then
		msg("关闭人物对话框");
		click(blankPoint[1],blankPoint[2]);
		delay(1000);
		return 1;
	end	
	local x,y = findColor(screenRange, 
		wyjy[1],wyjy[2])--我有经验
	if x~=-1 then
		msg("我有经验");
		click(x, y);
		delay(1000);
		return 1;
	end	
	local x,y = findColor(screenRange, 
		zhandoushibai[1],zhandoushibai[2])--战斗失败
	if x~=-1 then
		msg("战斗失败");
		click(blankPoint[1], blankPoint[2]);
		delay(1000);
		return 1;
	end
	if not fgt then
		fighting();
	end
end

function supply()
	--判断血
	local red = findPointFuzzy(supply_red[1],supply_red[2], supply_red[3]);
	--判断蓝
	local blue = findPointFuzzy(supply_blue[1],supply_blue[2], supply_blue[3]);
	-- red = false;--测试开启
	-- blue = false;
	if red and blue then
		return;
	end
	local n = 0;
	while n<5 do
		msg("自动补药");
		click(renwuPoint[1],renwuPoint[2]);--打开人物界面
		delay(1000);
		getpm();
		local x,y = findColor(screenRange,
			bnhx[1],bnhx[2])--包裹红叉
		if x~=-1 then
			click(renwuxinxiPoint[1],renwuxinxiPoint[2]);--打开信息
			delay(1000);
			--买药
			if not red then
				msg("补血");
				click(buyRed[1],buyRed[2]);
				delay(1000);
			end
			if not blue then
				msg("补蓝");
				click(buyBlue[1],buyBlue[2]);
				delay(1000);
			end
			for i=1,3 do
				getpm();
				local x,y = findColor(gman_Point,
					 gman_colorMis[1],gman_colorMis[2])--购买按钮
				if x~=-1 then
					msg("购买物品");
					click(x, y);
					delay(1000);
				end	
				getpm();
				local x,y = findColor(syan_range, 
					syan[1],syan[2])--使用按钮
				if x~=-1 then
					msg("使用物品");
					click(x, y);
					delay(1000);
				end	
			end
			close();
			break;
		end
		n=n+1;
	end

	--吃药
	getpm();
	local x,y = findColor(screenRange,
		 baonang[1],baonang[2])--包囊图标
	if x~=-1 then
		msg("打开包囊，吃药。");
		click(x, y);
		delay(1000);
	end
	click(wpanPoint[1],wpanPoint[2]);--点击物品
	delay(1000);
	click(zlanPoint[1],zlanPoint[2]);--整理包囊
	delay(1000);
	local n = 0;
	while n<5 do
		getpm();
		local x1,y1 = findColor(screenRange,
			supply_hongdougen[1],supply_hongdougen[2])--红罗羹
		if x1~=-1 then
			msg("使用红罗羹");
			click(x1, y1);
			delay(1000);
			local x = 0;
			local y = 0;
			while x~=-1 do
				getpm();
				x,y = findColor(supply_syanRange, 
					syan[1],syan[2])--使用按钮
				if x~=-1 then
					msg("使用物品");
					click(x, y);
					delay(1000);
				end	
			end
			click(zlanPoint[1],zlanPoint[2]);--整理包囊
			delay(1000);
		end	
		local x2,y2 = findColor(screenRange,
			 supply_lvdougen[1],supply_lvdougen[2])--绿芦羹
		if x2~=-1 then
			msg("使用绿芦羹");
			click(x2, y2);
			delay(1000);
			local x = 0;
			local y = 0;
			while x~=-1 do
				getpm();
				x,y = findColor(supply_syanRange, 
					syan[1],syan[2])--使用按钮
				if x~=-1 then
					msg("使用物品");
					click(x, y);
					delay(1000);
				end	
			end
			click(zlanPoint[1],zlanPoint[2]);--整理包囊
			delay(1000);
		end	
		if x1==-1 and x2==-1 then
			n=n+1;
		else
			n=0;
		end
	end
	close();
	msg("补给完毕");
	delay(1000);
end

function gameScreen()
	local n = 0;
	while n<20 do
		getpm();
		local Point1 = findPointFuzzy(yxzjm_Point[1][1],yxzjm_Point[1][2],yxzjm_color[1]);
		local Point2 = findPointFuzzy(yxzjm_Point[2][1],yxzjm_Point[2][2],yxzjm_color[2]);
		local Point3 = findPointFuzzy(yxzjm_Point[3][1],yxzjm_Point[3][2],yxzjm_color[3]);
		local Point4 = findPointFuzzy(yxzjm_Point[4][1],yxzjm_Point[4][2],yxzjm_color[4]);
		if Point1 and Point2 and Point3 and Point4 then
			supply();
			-- msg("游戏主界面");
			-- delay(500);
			return true;
		else
			n = n + 1;
			msg("不在游戏主界面,尝试进入");
			delay(500);
			local closetrue = close();
			if closetrue~=1 then
				registerGame();
			end
		end
	end
	msg("无法回到游戏主界面");
	delay(1000);
	os.exit();
	return false;
end

function registerGame()
	getpm();
	local x,y = findColor(jsxy_range,
		jsxy[1],jsxy[2])--接受协议按钮
	if x~=-1 then
		msg("接受协议");
		click(x, y);
		delay(1000);
		return;
	end
	local x,y = findColor(screenRange,
		dlzh[1],dlzh[2])--登录帐号按钮
	if x~=-1 then
		msg("登录帐号");
		click(x, y);
		delay(1000);
		return;
	end
	local x,y = findColor(whgg_range,
		whgg[1],whgg[2])--维护公告
	if x~=-1 then
		msg("维护公告");
		click(x, y);
		delay(1000);
		return;
	end
	local x,y = findColor(screenRange,
		rhxy[1],rhxy[2])--用户协议
	if x~=-1 then
		msg("用户协议");
		click(x, y);
		delay(1000);
		return;
	end
	local x,y = findColor(screenRange,
		dlyx[1],dlyx[2])--登录按钮
	if x~=-1 then
		msg("点击登录");
		click(x, y);
		delay(5000);
		return;
	end
	msg("尝试点击");
	click(screenPoint[1],screenPoint[2]);
	delay(1000);
end








main();