
--------------------------------------------
---添加面板，为了方便阅读相关内容全部放在这里
function TUO_Developer_Tool_kit:AddPanels()
	---全输入监测（已完成）（键盘、鼠标、手柄）---------------------------------------------------------
		self.hud.NewPanel('输入监测', nil,
			function(panel)
				TUO_Developer_HUD:NewWidget(panel,'slot1','value_displayer',{title='table:KeyState',monitoring_value=KeyState})
			TUO_Developer_HUD:NewWidget(panel,'slot1','value_displayer',{title='table:setting.keys',monitoring_value=setting.keys})
			TUO_Developer_HUD:NewWidget(panel,260,'value_displayer',{title='table:JoyState',monitoring_value=JoyState})
			TUO_Developer_HUD:NewWidget(panel,260,'value_displayer',{title='手柄可量化输入',
				monitoring_value=function(widget)
					local t={}
					local leftX,leftY,rightX,rightY=lstg.XInputManager.GetThumbState(1)
					local leftT,rightT=lstg.XInputManager.GetTriggerState(1) 
					table.insert(t,{name='leftThumb_X',v=leftX})
					table.insert(t,{name='leftThumb_Y',v=leftY})
					table.insert(t,{name='rightThumb_X',v=rightX})
					table.insert(t,{name='rightThumb_Y',v=rightY})
					table.insert(t,{name='leftTrigger',v=leftT})
					table.insert(t,{name='rightTrigger',v=rightT})
					return t
				end
				})
			TUO_Developer_HUD:NewWidget(panel,260,'value_displayer',{title='手柄原始按键状态',
				monitoring_value=function(widget)
					-- 在只插入一个手柄的情况下joy1和joy2是重复的
					local t={}
					for i=1,32 do
						table.insert(t,{name='JOY1_'..i,v=lstg.GetKeyState(KEY['JOY1_'..i])})
					end
					return t
				end
				})
			TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{title='鼠标状态',
				monitoring_value=function(widget)
					local t={}
					local x,y=GetMousePosition()
					local ux,uy=ScreenToUI(lstg.GetMousePosition())
					if not panel.MouseState then panel.MouseState={} end
					table.insert(t,{name='横坐标(窗口)',v=x})
					table.insert(t,{name='纵坐标(窗口)',v=y})
					table.insert(t,{name='滚轮滚动',v=MouseState.WheelDelta})
					table.insert(t,{name='横坐标(UI)',v=string.format('%.1f',ux)})
					table.insert(t,{name='纵坐标(UI)',v=string.format('%.1f',uy)})
					for i=0,7 do table.insert(t,{name='鼠标按键'..i,v=lstg.GetMouseState(i)}) end
					return t
				end})
			TUO_Developer_HUD:NewWidget(panel,'slot2','value_displayer',{title='按键被按下',
				monitoring_value=function(widget)
					local t={}
					for k,v in pairs(KeyState) do
						table.insert(t,{name=k,v=KeyTrigger(k)})
					end
					return t
				end})

		end)
	
	
	---游戏变量监测---------------------------------------------------------
		--包括以下数值的显示和修改：
		--------（游戏基本数值）分数，残机，奖残计数，符卡，符卡奖励计数，灵力，灵力上限，最大得点，擦弹，擦弹计数，每个单位的hp
		--------（特殊系统数值）梦现指针值，连击数，玩家对每个单位的DPS
		local var={--'score','lifeleft','chip','bomb','bombchip','power','faith','pointrate','graze',
			'missed_in_chapter','spelled_in_chapter','ccced_in_chapter',
			'block_spell','is_practice','ran_seed'}
		for __k,__V in pairs(var) do var[__k]='lstg.var.'..__V end

		self.hud.NewPanel('游戏系统调试',nil,
		function(panel)
			--作弊
				TUO_Developer_HUD:NewWidget(panel,440,'switch',{
					title='基础系统',
					monitoring_value='cheat',
					text_on='无敌模式：开',
					text_off='无敌模式：关',
					})
			--显示分数
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.score',text='分数'})
			--残机和碎片
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.lifeleft',text='残机'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_gauge',{monitoring_value='lstg.var.lifeleft',max_value=11})
				TUO_Developer_HUD:NewWidget(panel,440,'button',{text='残机归零',
				_event_mouseclick=function(widget)
					lstg.var.lifeleft=0
				end
				})
				for i=1,11 do
					TUO_Developer_HUD:NewWidget(panel,440,'button',{
						text=tostring(i),
						width=12,
						x_pos2=12*i+112,
						_lifeleft=i,
						_event_mouseclick=function(widget) lstg.var.lifeleft=widget._lifeleft end
					})
				end
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.chip',text='残机充能槽'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_slider',{monitoring_value='lstg.var.chip',max_value=300})
			--显示符卡和碎片
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.bomb',text='符卡剩余数'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_gauge',{monitoring_value='lstg.var.bomb',max_value=3})
				TUO_Developer_HUD:NewWidget(panel,440,'button',{text='Set Bomb to 0',
				_event_mouseclick=function(widget)
					lstg.var.bomb=0
				end
				})
				for i=1,3 do
					TUO_Developer_HUD:NewWidget(panel,440,'button',{
						text=tostring(i),
						width=24,
						x_pos2=24*i+100,
						_bomb=i,
						_event_mouseclick=function(widget) lstg.var.bomb=widget._bomb end
					})
				end
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.bombchip',text='符卡充能槽'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_slider',{monitoring_value='lstg.var.bombchip',max_value=300})
			--抛瓦
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.power',text='抛瓦'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_gauge',{monitoring_value='lstg.var.power',max_value=600})
				TUO_Developer_HUD:NewWidget(panel,440,'button',{text='Set power to 0',
				_event_mouseclick=function(widget)
					lstg.var.power=0
				end
				})
				for i=1,6 do
					TUO_Developer_HUD:NewWidget(panel,440,'button',{
						text=tostring(i),
						width=24,
						x_pos2=24*i+100,
						_power=i*100,
						_event_mouseclick=function(widget) lstg.var.power=widget._power end
					})
				end
			--绿点和擦弹
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.faith',text='最大得点基础值'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.pointrate',text='最大得点'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.graze',text='擦弹'})


			--梦现指针系统
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{title='梦现指针系统',monitoring_value='lstg.var.dr',text='梦现指针值'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_slider',{monitoring_value='lstg.var.dr',min_value=-5,max_value=5})
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value='lstg.var.cp',text='连击值'})
				TUO_Developer_HUD:NewWidget(panel,440,'value_slider',{monitoring_value='lstg.var.cp',max_value=5})
			--其他信息
				TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{title='其他信息',monitoring_value='lstg.var.player_name',text='机体名'})
				for i,v in pairs(var) do
					TUO_Developer_HUD:NewWidget(panel,440,'value_displayer',{monitoring_value=var[i]})
				end



			
			
		end)

	---关卡debug:设置和快速重启关卡并跳转到指定部分，设置和跳过boss符卡，（以多种模式）查看、输出和调整判定
		self.hud.NewPanel('关卡调试',nil,function(panel)
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				title='快速启动',
				text='该面板正在开发中，下面的按钮没有任何功能。\n难度:'
			})
			for i,v in pairs(stage_diffs) do
				TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
					_index=i,
					text=v,
					width=60,
					x_pos2=(i-1)*64
				})
			end
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				text='机体:'
			})
			for i,v in pairs(player_list) do
				TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
					_index=i,
					text=v[3],
					width=60,
					x_pos2=(i-1)*64
				})
			end
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				text='关卡选择:'
			})
			for i,v in pairs(stage_choices) do
				local v_=v
				if i%2==0 then v_='Boss '..int(i/2) end
				TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
					_index=i,
					text=v_,
					width=50,
					x_pos2=(i-1)*54
				})
			end
			
			
		end)


	---资源列表显示和快速重载（可能需要修改loadImage等等的定义）---------------------------------------------------------

		-- self.hud.NewPanel('Resource')
		

	---使用脚本列表显示和快速重载---------------------------------------------------------
		---相关代码：Include定义

		self.hud.NewPanel('脚本管理',nil,function(panel)
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{title='操作',text='重载',
				_event_mouseclick=function(widget)  
					local list=widget.panel.list
					local dis=list.display_value
					local v_tmp={}
					for i,v in pairs(dis) do
						if list.selection[i] then table.insert(v_tmp,v.name) end
					end
					self.ReloadFiles(v_tmp)
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='反转',
				_event_mouseclick=function(widget)  
					local list=widget.panel.list
					local dis=list.display_value
					local v_tmp={}
					for i,v in pairs(dis) do
						if list.selection[i] then 
							lstg.included[v.name]=not lstg.included[v.name]
						end
					end
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='重载游戏',
				_event_mouseclick=function(widget) 
					ResetPool()
					lstg.included={}
					stage.Set('none', 'init') 
					lstg.DoFile('core.lua')
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='全选',
				_event_mouseclick=function(widget) 
					widget.panel.list.selection={}
					for i=1,#widget.panel.list.display_value do
						widget.panel.list.selection[i]=true
					end
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='全不选',
				_event_mouseclick=function(widget) 
					widget.panel.list.selection={}
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='save1',width=55,
				_event_mouseclick=function(widget) 
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='load1',x_pos2=65,width=55,
				_event_mouseclick=function(widget) 
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='save2',width=55,
				_event_mouseclick=function(widget) 
				end
				})
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{text='load2',x_pos2=65,width=55,
				_event_mouseclick=function(widget) 
				end
				})
			
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				title='Included Script List',
				text= '这个列表显示了已经载入的脚本。\n重载游戏会把游戏整个重载掉。\nsave和load按钮可以保存和载入您的选区信息。'
				})
			panel.list=TUO_Developer_HUD:NewWidget(panel,'slot1','list_box',{
				monitoring_value=lstg.included
			})

		end)

	---实时脚本载入------------------------------------------------------------------------
	-- self.hud.NewPanel('Quick Loader')


	---背景脚本的3D参数显示，可直接在游戏内调整和写入3D背景参数---------------------------------------------------------

		self.hud.NewPanel('3D背景',nil,function(panel)
			TUO_Developer_HUD:NewWidget(panel,'slot1','value_displayer',{
				monitoring_value=lstg.view3d
			})
		end)

	---临时变量监测（支持在动态添加）---------------------------------------------------------

		self.hud.NewPanel('变量监测',nil,function(panel)
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				title='快捷变量监测',
				text='在下方的输入框输入将要监测的变量并点确定按钮。\n支持的格式：\n        lstg (所有类型)\n        lstg.var (表中值)\n        lstg.var.power (表中表中值)\n        .....\n变量名：'
			})
			panel.history={}
			panel.inputer=TUO_Developer_HUD:NewWidget(panel,'slot1','inputer',{
				text=''
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
				text='确定',
				width=90,
				_event_mouseclick=function(widget)
					local panel=widget.panel
					if panel.inputer.text~='' then
						table.insert(panel.history,panel.inputer.text)
						panel.monitor_wid.monitoring_value=panel.inputer.text
						panel.monitor_wid.title='Now monitoring: '..panel.inputer.text
					else
						panel.monitor_wid.monitoring_value=nil
						panel.monitor_wid.title=nil
					end
				end
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
				text='清除',
				width=90,
				x_pos2=94,
				_event_mouseclick=function(widget)
					local panel=widget.panel
					panel.inputer.text=''
					panel.monitor_wid.monitoring_value=nil
					panel.monitor_wid.title=nil
				end
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				text='监测结果会在下方显示。'
			})
			panel.monitor_wid=TUO_Developer_HUD:NewWidget(panel,'slot1','value_displayer',{
				monitoring_value=nil
			})


			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{
				title='操作',
				text='回到顶部',
				_event_mouseclick=function(widget) widget.panel.y_offset_aim=0 end}
			)
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{
				title='历史记录',
				text='清除历史',
				_event_mouseclick=function(widget) 
					local his=widget.panel.history
					for k,v in pairs(his) do
						his[k]=nil
					end
				end}
			)
			TUO_Developer_HUD:NewWidget(panel,'slot2','button',{
				text='应用',
				_event_mouseclick=function(widget) 
					local panel=widget.panel
					local list=panel.list
					local his=panel.history
					local v_tmp={}
					for k,v in pairs(list.selection) do
						if v then table.insert(v_tmp,list.display_value[k].v) end
					end
					if #v_tmp==0 then
					elseif #v_tmp==1 then
						local text=v_tmp[1]
						panel.monitor_wid.monitoring_value=text
						panel.monitor_wid.title='Now monitoring: '..text
					else
						v_tmp.use_G=true
						panel.monitor_wid.monitoring_value=v_tmp
						panel.monitor_wid.title='Now monitoring: #variable values#'
					end
				end}
			)
			panel.list=TUO_Developer_HUD:NewWidget(panel,'slot2','list_box',{
				width=120,
				monitoring_value=panel.history
				}
			)

		end)

	---一些杂项和设置

		self.hud.NewPanel('其他',nil,function(panel)
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				title='杂项',
				text='改变背景透明度。'
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','value_slider',{
				monitoring_value='TUO_Developer_HUD.alpha',
				max_value=1
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				text='锁定这个插件。'
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
				text='锁定',
				_event_mouseclick=function(widget)
					TUO_Developer_Tool_kit.visiable=false 
					TUO_Developer_Tool_kit.hud.timer=0
					TUO_Developer_Tool_kit.locked=true
					TUO_Developer_Tool_kit.unlock_time_limit=0
					TUO_Developer_Tool_kit.unlock_count=0
				end
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				text='重载所有面板。'
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
				text='重载 (F5)',
				_event_mouseclick=function(widget)
					TUO_Developer_Tool_kit:RefreshPanels()
				end
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				text='重载整个插件，请小心操作。'
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
				text='重载 (Shift + F5)',
				_event_mouseclick=function(widget)
					TUO_Developer_Tool_kit:Reload()
				end
			})
			--玩家分数记录器
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				title='Player\'s score recorder',
				text='alfhhjsadlfiaiwbelkgddhzcbdiu'
			})
			panel.email_inputer=TUO_Developer_HUD:NewWidget(panel,'slot1','inputer',{
				text='e-mail'
			})
			panel._player_info={}
			TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
				text='Confirm',
				_event_mouseclick=function(widget)
					local panel=widget.panel
					local key=widget
					local email=panel.email_inputer.text
					if (panel._player_info[email] or 0) > lstg.var.score then return end
					panel._player_info[email]=lstg.var.score
				end
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','list_box',{
				monitoring_value=panel._player_info,
			})


			--效果开关
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				title='效果开关',
				text='以下是为电脑配置低的用户准备的选项。'
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','switch',{
				text_on='关卡背景：开',
				text_off='关卡背景：关',
				flag=true
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','switch',{
				text_on='符卡背景展开和收回效果：开',
				text_off='符卡背景展开和收回效果：关',
				flag=true
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','switch',{
				text_on='开卡特效：开',
				text_off='开卡特效：关',
				flag=true
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','switch',{
				text_on='其他特效：开',
				text_off='其他特效：关',
				flag=true
			})
			--沙盒
			_you_can_never_find_this_variable=23333333
			TUO_Developer_HUD:NewWidget(panel,'slot1','value_displayer',{
				title='沙盒（高危试验场地）',
				monitoring_value='_you_can_never_find_this_variable'
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','value_gauge',{
				monitoring_value='_you_can_never_find_this_variable',
				max_value=23333333
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','value_slider',{
				monitoring_value='_you_can_never_find_this_variable',
				max_value=23333333
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','button',{
				text='Hello LuaSTG!',
				_event_mouseclick=function()  end}
			)
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				text='Hello LuaSTG!'
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','text_displayer',{
				text='华文隶书大胜利！！！'
			})

			TUO_Developer_HUD:NewWidget(panel,'slot1','switch',{
				text_on='Ohhhh man!',
				text_off='Creeper?'
			})

			TUO_Developer_HUD:NewWidget(panel,'slot1','switch',{
				text_on='test|test',
				text_off='test test'
			})
			TUO_Developer_HUD:NewWidget(panel,'slot1','inputer',{
				text='但是你打不了中文啊（悲）',
			})

			TUO_Developer_HUD:NewWidget(panel,'slot1','list_box',{
				monitoring_value='lstg',
			})
		end)
end

function TUO_Developer_Tool_kit:RefreshPanels()
	local PATH_HEAD='Library\\plugins\\TUO_Developer_Tool_kit\\'
	local DoFilePlus=function(path)
		if lfs.attributes(path) == nil then
			path=PATH_HEAD..path
		end 
		TUO_Developer_Tool_kit.ReloadSingleFile(path)
	end
	DoFilePlus"TUO_Dev_Panel_Define.lua"
	DoFilePlus"TUO_Dev_Widget_Template.lua"
	self.hud.panel={}
	self:AddPanels()
end