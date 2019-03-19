LoadImageFromFile('chapFin','THlib\\chapFin.png')
--用于结算点的obj，奖励chapter分数，结算残机和符卡，以及重置计数
ChapFin=Class(_object)
ChapFin.init=function(self,_x,_y,_)
    self.x,self.y=0,75
	self.img='chapFin'
	self.layer=LAYER_TOP
	self.group=GROUP_GHOST
	self.hide=false
	self.bound=false
	self.navi=false
	self.hp=10
	self.maxhp=10
	self.colli=false
	self._blend,self._a,self._r,self._g,self._b='',255,255,255,255
	--重置梦现指针
	DR_Pin.reset()
	
	--kill所有杂鱼
	for _,unit in ObjList(GROUP_ENEMY) do
		if unit~=_boss then
			unit.drop=false
			_kill(unit,true)
		else
		end
	end    
	_clear_bullet(false,false)
	
	task.New(self,function()
        --动画效果
		do local s,_d_s=(1),(-0.5/29) local trans,_d_trans=(0),(255/29) for _=1,30 do
            self.hscale=s
            self.vscale=s
            self._a=trans
            task._Wait(1)
        s=s+_d_s trans=trans+_d_trans end end
		--残机结算
		if lstg.var.chip>=100 and (not IsValid(_boss)) then
			lstg.var.lifeleft,lstg.var.chip=lstg.var.lifeleft+math.modf(lstg.var.chip),lstg.var.chip%100--这里的modf会返回参数的整数和小数部分，我就当fix()用了
			PlaySound('extend',0.5)
			New(hinter,'hint.extend',0.6,0,112,15,120)
		end
		--符卡结算
		if lstg.var.bombchip>=100 and (not IsValid(_boss)) then
			lstg.var.bomb,lstg.var.bombchip=lstg.var.bomb+math.modf(lstg.var.bombchip),lstg.var.bombchip%100
			if lstg.var.bomb==3 then lstg.var.bombchip=0 end
			PlaySound('cardget',0.8)
		end 
		task._Wait(120)
		_del(self,true)
    end)
	
end
