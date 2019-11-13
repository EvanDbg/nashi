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
	-- ReMission(cgrw_bprwMis,remission_hd_bprwMis,2);
	--ReMission(cgrw_smrwMis,remission_hd_smrwMis);
-- 	getpm()
-- 	silverNumberString = ocrText({531,276,691,312},"0123456789",240,255);
-- msg(silverNumberString)
-- delay(5000)
	welfare();
	local m = 0;
	local xunhuan = getInt("917")+1;
	while m<xunhuan do
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
		local i = 0;
		while i<sort do
			i = i + 1;
			missionTable = getMission();
			sort = #missionTable;
			if getSwitch("901") and (missionTable[i] == "师" or #missionTable==0) and getString() == "师" then
				gameScreen();
				shimen();
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("902") and (missionTable[i] == "鬼" or #missionTable==0) and getString() == "鬼" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				zhuagui();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("903") and (missionTable[i] == "打" or #missionTable==0) and getString() == "打" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				dabaotu();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("904") and (missionTable[i] == "挖" or #missionTable==0) and getString() == "挖" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				wabaotu();
				clear();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("905") and (missionTable[i] == "封" or #missionTable==0) and getString() == "封" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				fengyao();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("906") and (missionTable[i] == "普" or #missionTable==0) and getString() == "普" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				putongyabiao();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("907") and (missionTable[i] == "高" or #missionTable==0) and getString() == "高" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				gaojiyabiao();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("908") and (missionTable[i] == "答" or #missionTable==0) and getString() == "答" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				dati();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("909") and (missionTable[i] == "副" or #missionTable==0) and getString() == "副" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				fuben();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("910") and (missionTable[i] == "秘" or #missionTable==0) and getString() == "秘" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				mijing();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("911") and (missionTable[i] == "环" or #missionTable==0) and getString() == "环" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				paohuan();
				missionPlan(i,sort,missionTable);
			end
			if getSwitch("912") and (missionTable[i] == "帮" or #missionTable==0) and getString() == "帮" then
				-- if i<sort then
				-- 	setString(missionTable[i+1]);
				-- end
				gameScreen();
				bangpai();
				missionPlan(i,sort,missionTable);
			end
		end--for sort
		if getSwitch("500") then
			pinghuo();
		end
		m = m + 1;
		xunhuan = getInt("917")+1;
	end
end

function missionPlan(i,sort,table)
	if i<sort then
		setString(table[i+1]);
	end
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

function menpaichuangguan()
	msg("门派闯关开始");
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

function mijing()
	msg("秘境任务开始");
	delay(1000);
	--找活动图标
	msg("打开活动面板");
	click(remission_hd[1],remission_hd[2]);--点击活动
	delay(1000);
	click(remission_rchd[1],remission_rchd[2]);--点击日常活动
	delay(1000);
	move(0,remission_hd_up[1],remission_hd_up[2],remission_hd_up[3]);--滑动最上面
	delay(1000);
	local i = 0;
	while i<3 do
		getpm();
		local x,y = findColor(remission_hdrange,
			hd_mijing[1],hd_mijing[2]);--活动界面秘境
		if x~=-1 then
			msg("点击目标");
			click(x, y);
			delay(2000);
			break;
		end
		i = i + 1;
		move(1,remission_hd_down[1],remission_hd_down[2],remission_hd_down[3]);
		delay(1000);
	end
	if i==3 then
		gameScreen();--主界面
		msg("秘境完成");
		delay(1000);
		return;
	end
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
				break;
			end
		else
			n=n+1;
			msg("人物对话等待:"..tostring(n));
			delay(1000);
		end
	end
	if n==10 then
		gameScreen();--主界面
		msg("秘境完成");
		delay(1000);
		return;
	end
	local m = 0;
	while m<5 do
		findGuide();
		getpm();
		local x,y = findColor(screenRange, 
			mijingkaishi[1],mijingkaishi[2])--数字1
		if x~=-1 then
			m=0;
			msg("进入秘境");
			click(x+kaishipianyi, y-kaishipianyi);
			delay(1000);
			click(jinrumijing[1],jinrumijing[2]);
			delay(3000);
			break;
		else
			m = m + 1;
			msg("等待:"..tostring(m));
			delay(1000);
		end
	end
	if m==5 then
		gameScreen();--主界面
		msg("秘境完成");
		delay(1000);
		return;
	end
	gameScreen();
	local fgt = 0;
	local out = 0;
	local zhandouduoci = 0;
	local guan = getInt("916") + 1;
	while fgt<guan and out<20 do
		getpm();
		local Point1 = findPointFuzzy(yxzjm_Point[1][1],yxzjm_Point[1][2],yxzjm_color[1]);
		local Point2 = findPointFuzzy(yxzjm_Point[2][1],yxzjm_Point[2][2],yxzjm_color[2]);
		local Point3 = findPointFuzzy(yxzjm_Point[3][1],yxzjm_Point[3][2],yxzjm_color[3]);
		local Point4 = findPointFuzzy(yxzjm_Point[4][1],yxzjm_Point[4][2],yxzjm_color[4]);
		if Point1 and Point2 and Point3 and Point4 then
			if out>=19 or out==0 then
			local x,y = findColor(missionRange, 
				mijinglikai[1],mijinglikai[2])--离开
			if x~=-1 then
				out = 0;
				msg("点击任务");
				click(x,y-likaipianyi);--任务
				delay(1000);
			end
			end
		end
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
		else
			close(true);
		end
		local x,y = findColor(screenRange, 
				mijinglibao[1],mijinglibao[2])--礼包
		if x~=-1 then
			msg("领礼包")
			click(x, y);
			delay(1000);
		end
		local fight = rayfighting();
		if fight then
			out = 0;
			fgt = fgt + 1;
			if fgt>5 then
				msg("战斗次数:"..tostring(fgt));
				delay(500);
			end
		else
			out = out + 1;
			msg("当前任务等待:"..tostring(out));
			delay(500);
		end
		getpm();
		local x,y = findColor(screenRange, 
			zhandoushibai[1],zhandoushibai[2])--战斗失败
		if x~=-1 then
			zhandouduoci = zhandouduoci + 1;
			msg("战斗失败");
			click(blankPoint[1], blankPoint[2]);
			delay(1000);
			if getInt("916") == 0 or zhandouduoci>=3 then
				break;
			end
		end
		guan = getInt("916") + 1;
		if getInt("916") == 0 then
			guan = fgt + 1;
		end
	end
	local m = 0;
	while m<5 do
		getpm();
		local x,y = findColor(missionRange, 
			mijinglikai[1],mijinglikai[2])--离开
		if x~=-1 then
			msg("离开");
			click(x, y);
			delay(1000);
			break;
		else
			m=m+1;
			delay(1000);
		end
	end

	msg("秘境完成");
	delay(1000);
end

function rayfighting()
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
			-- mSleep(100);
			delay(200);
			close(true);
		else
			-- msg("battle ending...");
			break;
		end
		local x,y = findColor(zdfgt_Point, 
			zdfgt_colorMis[1],zdfgt_colorMis[2])
		if x~=-1 then
			msg("Auto");
			click(x, y);
			delay(1000);
		end
	end
	
	return true;
end

function fengyao()
	msg("封妖任务开始");
	delay(1000);
	while true do
		--找活动图标
		msg("打开活动面板");
		click(remission_hd[1],remission_hd[2]);--点击活动
		delay(1000);
		click(remission_rchd[1],remission_rchd[2]);--点击日常活动
		delay(1000);
		move(0,remission_hd_up[1],remission_hd_up[2],remission_hd_up[3]);--滑动最上面
		delay(1000);
		--找封妖活动
		local i = 0;
		while i<3 do
			getpm();
			local x,y = findColor(remission_hdrange,
				huodongfengyao[1],huodongfengyao[2]);
			if x~=-1 then
				msg("点击目标");
				click(x, y);
				delay(5000);
				break;
			end
			i = i + 1;
			move(1,remission_hd_down[1],remission_hd_down[2],remission_hd_down[3]);
			delay(1000);
		end
		if i==3 then
			gameScreen();--主界面
			msg("封妖任务完成");
			delay(1000);
			break;
		end
		--判断主界面
		gameScreen();
		--关闭任务
		msg("关闭任务栏")
		click(renwulansuofang[1],renwulansuofang[2]);
		delay(1000);
		local fgt = 0;
		local out = 0;
		local upDown = false;
		while fgt<10 and out<10 do
			--判断主界面
			gameScreen();
			--打开小地图
			msg("打开小地图")
			click(xiaodituPoint[1],xiaodituPoint[2]);--打开小地图
			delay(1000);
			local litteMap = false;
			getpm();
			if not upDown then
			    --找到上角
				upDown = true;
				local x,y = findColor(screenRange,
					 shangjiao[1],shangjiao[2]);
				if x~=-1 then
					litteMap = true;
					msg("上方");
					click(x+xiaoditupianyi,y+xiaoditupianyi);
					delay(1000);
				end
			else
			    --找到下角
				upDown = false;
				local x,y = findColor(screenRange,
					 xiajiao[1],xiajiao[2]);
				if x~=-1 then
					litteMap = true;
					msg("下方");
					click(x-xiaoditupianyi,y-xiaoditupianyi);
					delay(1000);
				end
			end

			if litteMap then
				out = 0;
				local fight = false;
				local i = 0;
				while i<20 do
					--找远古
					--判断主界面
					gameScreen();
					getpm();
					local x,y = findArrayColor(fengyao_yuangurange, fengyao_yuangumis);
					if x~=-1 then
						msg("攻击远古");
						click(x+gongjiyuangupianyi[1], y-gongjiyuangupianyi[2]);
						delay(1000);
						getpm();
						local xx,yy = findArrayColor(screenRange, fengyao_xuanzeyuangumis);
						if xx~=-1 then
							msg("选择远古");
							click(xx, yy);
							delay(1000);
						end
						local n = 0;
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
								close(true);
								break;
							else
								n=n+1;
								msg("等待对话:"..tostring(n));
								delay(1000);
							end
						end
					elseif fight then
						break;
					end
					fight = fighting();
					if fight then
						fgt = fgt + 1;
						msg("战斗次数:"..tostring(fgt));
						delay(1000);
						if fgt < 10 then
							msg("关闭任务栏");
							click(renwulansuofang[1],renwulansuofang[2]);
							delay(1000);
						else
							break;
						end
					end
					i = i + 1;
					msg("当前任务等待:"..tostring(i));
					delay(1000);
				end
			else
				out = out + 1;
			end
		end
		if fgt >= 10 then
			break;
		end
	end

	msg("封妖完成");
	delay(1000);
end

function bangpai()
	msg("帮派任务开始");
	delay(1000);
	mission(bangpairenwu,4);
	msg("帮派任务完成");
	delay(1000);
end

function welfare()
	if getSwitch("503") then
		gameScreen();
		msg("领取每日福利");
		delay(1000);
		scratchTicket();
		msg("领取完成");
		delay(1000);
	end
end

function scratchTicket()

	msg("打开福利界面");
	click(fuliPoint[1],fuliPoint[2]);--福利坐标
	delay(1000);
	local i = 0;
	while i<5 do
		getpm();
		local x,y = findColor(screenRange,
			 ggl_colorMis[1],ggl_colorMis[2])--刮刮乐
		if x~=-1 then
			msg("刮刮乐");
			click(x,y);--刮刮乐
			delay(1000);
			break;
		end
		i = i + 1;
		delay(1000);
	end
	for i=0,2 do
		msg("刮"..tostring(i+1).."下");
		moveScratch(ggl_move[1],ggl_move[2] + i*ggl_move_py,ggl_move[3]);
		delay(700);
	end

	for i=0,2 do
		msg("领取累计:"..tostring(i+1));
		click(ggl_lingquPoint[1] + i*ggl_lingquPoint_py,ggl_lingquPoint[2]);
		delay(500);
		click(screenPoint[1],screenPoint[2]);
		delay(1000);
	end

	gameScreen();
end

function moveScratch(x,y,dis)--刮刮乐专业
	getOrien();
	local ranx = x;
	local rany = y;
	local s = math.random(50,200);
	touchDown(1,ranx,rany);
	mSleep(s);
 	while ranx<=x+dis do
 		ranx = ranx + math.random(20,30);
 		s = math.random(20,50);
 		touchMove(1,ranx,rany);
 		mSleep(s);
 	end
	touchUp(1,ranx,rany);
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
			gameScreen();
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
						msg("人物对话等待:"..tostring(n));
						delay(1000);
					end
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
	local backbool = false;
	local goldNumber = "";
	local silverNumber = "";
	local goldNumberString = "";
	local silverNumberString = "";
	local renwu1 = {};
	local remwu2 = {};
	local silverRange = {};
	if lx == 1 then--师门
		goldNumber = "913";
		renwu1 = cgrw_smrwMis;
		renwu2 = remission_hd_smrwMis;
	elseif lx == 4 then--帮派
		goldNumber = "914";
		silverNumber = "915";
		renwu1 = cgrw_bprwMis;
		renwu2 = remission_hd_bprwMis;
	end
	getpm();
	local x,y = findColor(screenRange, 
		baitan[1],baitan[2])--摆摊界面
	if x~=-1 then
		goldNumberString = ocrText(baitanjiege,"0123456789",jinbimis[1],jinbimis[2]);
	end
	local x,y = findColor(screenRange, 
		shanghui[1],shanghui[2])--选中物品
	if x~=-1 then
		silverRange = {x,y,x+baitanyibi[1],y+baitanyibi[2]};
	end
	if #silverRange ~= 0 then
		silverNumberString = ocrText(silverRange,"0123456789",yinbimis[1],yinbimis[2]);
	end
	if goldNumberString ~= "" then
		msg("金币价格:"..goldNumberString);
		delay(1000);
		if tonumber(goldNumberString) > getInt(goldNumber)*10 then
			ReMission(renwu1,renwu2,lx);
			backbool = true;
		end
	elseif silverNumberString ~= "" then
		msg("银币价格:"..silverNumberString);
		delay(1000);
		if tonumber(silverNumberString) > getInt(silverNumber)*10000 then
			ReMission(renwu1,renwu2,lx);
			backbool = true;
		end
	end
	if goldNumberString == "" and silverNumberString == "" then
		backbool = true;
	end
	return backbool;
end

function ReMission(abandon,receive,lx,xunzhao)--lx类型1师门4帮派
	while true do
		if not xunzhao then
			msg("重接任务");
			delay(1000);
			gameScreen();--主界面
			click(missionBookClick[1],missionBookClick[2]);--点击打开任务界面
			delay(1000);
			click(dangqianrenwu[1],dangqianrenwu[2]);--点击当前任务
			delay(1000);
			--下滑
			move(0,cgrw_down[1],cgrw_down[2],cgrw_down[3]);
			delay(1000);
			--找到常规任务,判断是不是打开的
			getpm();
			local x,y = findColor(cgrw_range,
				cgrw_colorMis[1],cgrw_colorMis[2]);
			if x~=-1 then
				msg("常规任务打开");
				click(x, y);
				delay(1000);
			end
			--找到目标任务
			getpm();
			local x,y = findColor(cgrw_range,
				abandon[1],abandon[2]);
			if x~=-1 then
				msg("选择目标任务");
				click(x, y);
				delay(1000);
				msg("放弃任务");
				click(remission_fq[1],remission_fq[2]);--放弃
				delay(1000);
				click(remission_qd[1],remission_qd[2]);--确定
				delay(1000);
			end
		end
		gameScreen();--主界面
		--重新接任务
		msg("打开活动面板");
		click(remission_hd[1],remission_hd[2]);--点击活动
		delay(1000);
		click(remission_rchd[1],remission_rchd[2]);--点击日常活动
		delay(1000);
		move(0,remission_hd_up[1],remission_hd_up[2],remission_hd_up[3]);--滑动最上面
		delay(1000);
		local i = 0;
		while i<3 do
			getpm();
			local x,y = findColor(remission_hdrange,
				receive[1],receive[2]);
			if x~=-1 then
				msg("点击目标");
				click(x, y);
				delay(1000);
				break;
			end
			i = i + 1;
			move(1,remission_hd_down[1],remission_hd_down[2],remission_hd_down[3]);
			delay(1000);
		end
		if i==3 then
			gameScreen();--主界面
			return false;
		end
		local m = 0;
		while m<10 do
			getpm();
			local x,y = findColor(rwdhk_Point, 
				 rwdhk_colorMis[1],rwdhk_colorMis[2])--人物对话框
			if x~=-1 then
				--判断是否有完成任务按钮没有就点击
				local color = dh_colorMis[1];
				local mis = dh_colorMis[2];
				if lx == 4 then
					color = bangpaiduihua_mis[1];
					mis = bangpaiduihua_mis[2];
				end
				local x1,y1 = findColor(dh_Point, 
					color,mis)--对话
				if x1~=-1 then
					msg("对话");
					click(x1, y1);
					delay(1000);
				else
					msg("关闭人物对话框");
					click(blankPoint[1],blankPoint[2]);
					delay(1000);
				end
				gameScreen();--主界面
				return true;
			end	
			m = m + 1;
			msg("当前任务等待："..tostring(m));
			delay(1000);
		end
	end--true
end

function mission(colorStr,lx)--lx类型1师门2主线3红尘4帮派
	local zhuxian = 0;
	local zhuxiantuichu = 0;
	local zhandou = false;
	while true do
		if lx == 2 or lx == 3 or lx ==4 then
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
				if lx == 4 then
					ReMission(cgrw_bprwMis,remission_hd_bprwMis,lx);
				elseif zhuxian == getInt("918") then
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
				if lx == 4 then
					local mission = ReMission(cgrw_bprwMis,remission_hd_bprwMis,lx,true);
					if not mission then
						return 0;
					end
					findMission(colorStr,lx);
				else
					return 0;
				end
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
					local judge = judgeMoney(lx);
					if judge then
						zhuxiantuichu=0;
						break;
					end
				end	
				i=0;
				m=m+1;
				zhandou = false;
				msg("购买物品");
				click(x, y);
				delay(1000);
				getpm();
				local x,y = findColor(screenRange,
					bnhx[1],bnhx[2])--包裹红叉
				if x~=-1 then
					msg("关闭包囊红叉");
					click(x, y);
					delay(1000);
				end
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
				if lx == 4 then
					i = 0;
					getpm();
					local x,y = findColor(rwdhk_Point, 
						 rwdhk_colorMis[1],rwdhk_colorMis[2])--人物对话框
					if x~=-1 then
						msg("关闭人物对话框");
						click(blankPoint[1],blankPoint[2]);
						delay(1000);
						zhandou = true;
						zhuxiantuichu=0;
						break;
					end	
				else
					zhandou = true;
					zhuxiantuichu=0;
					break;
				end
			end
			local juqing = dianjijuqing();
			if juqing then
				getpm();
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
	-- local x1,y1 = findColor(djtgjq_range, 
	-- 	djryjx_colorMis[1],djryjx_colorMis[2])--点击继续
	local x2,y2 = findColor(djtgjq_range, 
		djtgjq_colorMis[1],djtgjq_colorMis[2])--点击跳过
	if x2==-1 then
		return false;
	end
	local n = 0;
	local m = 0;
	while n<4 and m<20 do
		getpm();
		-- local x1,y1 = findColor(djtgjq_range, 
		-- 	djryjx_colorMis[1],djryjx_colorMis[2])--点击继续
		-- if x1~=-1 then
		-- 	msg("点击继续");
		-- 	click(x1, y1);
		-- 	delay(1000);
		-- end	
		local x2,y2 = findColor(djtgjq_range, 
			djtgjq_colorMis[1],djtgjq_colorMis[2])--点击跳过
		if x2~=-1 then
			n=0;
			m=m+1;
			msg("跳过剧情:"..tostring(m));
			click(x2, y2);
			delay(1000);
		else
			n=n+1;
			delay(200);
		end
	end
	msg("剧情结束");
	delay(500);
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
function findMission(missionColor,lx)--lx类型1师门2主线3红尘4帮派
	msg("寻找目标任务");
	delay(500);
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
			local py = 0;
			if lx == 2 then
				py = 20;
			end
			click(x, y + py);
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
	delay(600);
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
	msg("battle ending...");
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
	local x,y = findColor(screenRange,
		bnhx[1],bnhx[2])--包裹红叉
	if x~=-1 then
		msg("关闭包囊红叉");
		click(x, y);
		delay(1000);
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
		msg("关闭福利红叉");
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
		zqhx[1],zqhx[2])--坐骑红叉
	if x~=-1 then
		msg("关闭坐骑红叉");
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
	local x,y = findColor(screenRange,
		bpcphx[1],bpcphx[2])--帮派菜谱红叉
	if x~=-1 then
		msg("关闭帮派菜谱红叉");
		click(x, y);
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
	if not fgt then
		local x,y = findColor(rwdhk_Point, 
			rwdhk_colorMis[1],rwdhk_colorMis[2])--人物对话框
		if x~=-1 then
			msg("关闭人物对话框");
			click(blankPoint[1],blankPoint[2]);
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
			break;
		end
		n=n+1;
	end
	gameScreen(true);
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
	gameScreen(true);
	msg("补给完毕");
	delay(1000);
end

function gameScreen(buji)
	local n = 0;
	while n<20 do
		getpm();
		local Point1 = findPointFuzzy(yxzjm_Point[1][1],yxzjm_Point[1][2],yxzjm_color[1]);
		local Point2 = findPointFuzzy(yxzjm_Point[2][1],yxzjm_Point[2][2],yxzjm_color[2]);
		local Point3 = findPointFuzzy(yxzjm_Point[3][1],yxzjm_Point[3][2],yxzjm_color[3]);
		local Point4 = findPointFuzzy(yxzjm_Point[4][1],yxzjm_Point[4][2],yxzjm_color[4]);
		if Point1 and Point2 and Point3 and Point4 then
			if not buji then
				supply();
			end
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