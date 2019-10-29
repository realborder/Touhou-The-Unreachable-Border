local AllSetting=TUO_Developer_UI:NewModule()

function AllSetting:init()
    self.name='设置'
end


local setting=TUO_Developer_UI:NewPanel()
function setting:init()
    self.name="游戏设置"

    TDU_New_title(self).text='特效开关'
    TDU_New_text_displayer(self).text='关闭或开启游戏内特效，注意，这可能会使画面不会正常显示。\n目前可以调整的包括：\n    boss带来的背景扭曲特效\n    boss符卡展开特效\n    boss符卡宣告立绘特效\n    其他特效（如三面背景和魔理沙B机体的黑洞特效）'
    -- local sw1=TDU_New_switch(self)
    -- sw1.text_on="背景扭曲特效和符卡展开特效 启用"
    -- sw1.text_off="背景扭曲特效和符卡展开特效 禁用"
    -- sw1.monitoring_value='tuolib.effect_cut.enable_boss_effect'
    local sw2=TDU_New_switch(self)
    sw2.text_on="shader 启用"
    sw2.text_off="shader 禁用"
    sw2.monitoring_value='tuolib.effect_cut.enable_shader'
    local sw3=TDU_New_switch(self)
    sw3.text_on="背景 启用"
    sw3.text_off="背景 禁用"
    sw3.monitoring_value='tuolib.effect_cut.enable_background'
    sw3.enable=false
    TDU_New_title(self).text='游戏设置查看'
    TDU_New_value_displayer(self).monitoring_value='setting'
    TDU_New_title(self).text='world参数查看'
    TDU_New_value_displayer(self).monitoring_value='lstg.world'
    TDU_New_title(self).text='screen参数查看'
    TDU_New_value_displayer(self).monitoring_value='screen'

end

local toolsetting=TUO_Developer_UI:NewPanel()
function toolsetting:init()
    self.name="工具设置"
    TDU_New'title'(self).text='杂项'
    TDU_New'text_displayer'(self).text='改变背景透明度。'
    local slider=TDU_New'value_slider'(self)
    slider.monitoring_value='TUO_Developer_UI.bgalpha'
    slider.max_value=1

    TDU_New'text_displayer'(self).text='重载所有模块的布局。'
    local btn1=TDU_New'button'(self)
    btn1.text='重载 (F5)'
    btn1.width=96
    btn1._event_mouseclick=function(widget)
            TUO_Developer_Tool_kit:RefreshCurrentModule()
        end
    TDU_New'text_displayer'(self).text='重载整个内测功能面板。'
    local btn2=TDU_New'button'(self)
    btn2.text='重载 (Shift + F5)'
    btn2.width=145
    btn2.event_mouseclick=function(widget)
            TUO_Developer_Tool_kit:Reload()
        end
    


end
local sandbox=TUO_Developer_UI:NewPanel()
function sandbox:init()
    lstg.test_value=0
    self.name="控件测试"
    -- local title=TUO_Developer_UI:AttachWidget(self,'title')
    --     title.text='标题控件测试'
    local title=TDU_New_title(self)
        title.text='标题控件测试'

    local value_displayer=TUO_Developer_UI:AttachWidget(self,'value_displayer')
        value_displayer.monitoring_value='lstg.test_value'

    local value_gauge=TUO_Developer_UI:AttachWidget(self,'value_gauge')
        value_gauge.monitoring_value='lstg.test_value'
        value_gauge.max_value=480

    local value_slider=TUO_Developer_UI:AttachWidget(self,'value_slider')
        value_slider.monitoring_value='lstg.test_value'

    local button1=TUO_Developer_UI:AttachWidget(self,'button')
        button1.text='Hello LuaSTG!'

    local button2=TUO_Developer_UI:AttachWidget(self,'button')
        button2.text='Hello LuaSTG!'
        button2._stay_in_this_line=true

    local text_displayer=TUO_Developer_UI:AttachWidget(self,'text_displayer')
        text_displayer.text='Hello LuaSTG!'
        text_displayer.width=128

    local text_displayer2=TUO_Developer_UI:AttachWidget(self,'text_displayer')
        text_displayer2.text='Hello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!\nHello LuaSTG!'
        text_displayer2._stay_in_this_line=true

    local inputer=TUO_Developer_UI:AttachWidget(self,'inputer')
        inputer.text='lstg.world'

    local button2=TUO_Developer_UI:AttachWidget(self,'button')
        button2.text='Apply!'
        button2._stay_in_this_line=true

    local list_box
    local button3=TUO_Developer_UI:AttachWidget(self,'button')
        button3.text='Vanish'
        button3.width=96
        button3._event_mouseclick=function(self) list_box.visiable=false end

    local button4=TUO_Developer_UI:AttachWidget(self,'button')
        button4.text='Apprear'
        button4.width=96
        button4._stay_in_this_line=true
        button4._event_mouseclick=function(self) list_box.visiable=true end

    local button5=TUO_Developer_UI:AttachWidget(self,'button')
        button5.text='ban'
        button5.width=96
        button5._stay_in_this_line=true
        button5._event_mouseclick=function(self) list_box.enable=false end

    local button6=TUO_Developer_UI:AttachWidget(self,'button')
        button6.text='unban'
        button6.width=96
        button6._stay_in_this_line=true
        button6._event_mouseclick=function(self) list_box.enable=true end

    list_box=TUO_Developer_UI:AttachWidget(self,'list_box')
        list_box.monitoring_value='lstg.world'


    local switch=TUO_Developer_UI:AttachWidget(self,'switch')
        switch.monitoring_value='cheat'
        switch.text_on='cheat on'
        switch.text_off='cheat off'

    local color_sampler

    local switch2=TUO_Developer_UI:AttachWidget(self,'switch')
    switch2.monitoring_value=function(v) 
        return color_sampler.visiable
        -- if type(v)~=nil then color_sampler.visiable=v else return color_sampler.visiable end 
    end
    switch2._event_switched=function(self,v) 
        color_sampler.visiable=v
    end
    switch2.text_on='已显示色环'
    switch2.text_off='已隐藏色环'
    
    color_sampler=TUO_Developer_UI:AttachWidget(self,'color_sampler')

    TDU_New_text_displayer(self).text='游戏内直接选取颜色！！就问你爽不爽！'
    


end

local sandbox2=TUO_Developer_UI:NewPanel()
function sandbox2:init()
    self.name="浮窗测试"
    local btn1=TDU_New_button(self)
    btn1.text='通知浮窗'
    btn1._event_mouseclick=function(self)
        TUO_Developer_Flow:MsgWindow('开玩笑的wwwww\n')
        TUO_Developer_Flow:MsgWindow('他会一直纠缠你\n')
        TUO_Developer_Flow:MsgWindow('那你会永远也点不完\n')
        TUO_Developer_Flow:MsgWindow('如果你看到它\n')
        TUO_Developer_Flow:MsgWindow('这个消息提示框\n')
        TUO_Developer_Flow:MsgWindow('……\n')
        TUO_Developer_Flow:MsgWindow('不过吧……不知道你有没有听说过\n')
        TUO_Developer_Flow:MsgWindow('这个信息是随便编的，下面可以不用看了。\n')
        TUO_Developer_Flow:NewFlow('infowin',function() end)
    end
    local btn2=TDU_New_button(self)
    btn2.text='错误消息浮窗'
    btn2._event_mouseclick=function(self)
        TUO_Developer_Flow:NewFlow('errorwin',function(self) 
            local r,err=xpcall(error,debug.traceback,'错误信息是我编的')
            self.text=err
        end)
    end
end
local tip=[[
F1: 返回模块选择界面
F3: 显示/隐藏这个内测功能面板
F5: 重载所有模块的面板的布局
Shift+F5: 重载整个内测功能面板
F9: 榨干Boss（误
F10：重载在资源管理模块里选中的文件
Tab: 在模块内切换面板，同时按住Shift以反向切换
Ctrl+Tab: 切换模块，同时按住Shift以反向切换]]
local tips=TUO_Developer_UI:NewPanel()
function tips:init()
    self.name='帮助信息'
    TDU_New'title'(self).text='快捷键列表'
    TDU_New'text_displayer'(self).text=tip
end
local about_txt=[[
这个是为东方梦无垠开发者和内测人员准备的功能。
没了。]]
local about=TUO_Developer_UI:NewPanel()
function about:init()
    self.name='关于'
    TDU_New'text_displayer'(self).text=about_txt
end