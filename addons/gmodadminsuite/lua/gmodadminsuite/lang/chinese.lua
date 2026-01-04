return {
    Name = "Chinese",
    Flag = "flags16/cn.png",
    Phrases = function()
        return {
            open_menu = "打开菜单",
            menu_nopermission = "对不起，您没有权限访问GmodAdminSuite菜单。",
            menu_unknown_module = "对不起，该名称的模块未安装或不存在。",
            menu_disabled_module = "对不起，该模块已禁用。",
            menu_module_nopermission = "对不起，您没有权限访问此模块。",
            open_gas = "打开GmodAdminSuite",
            module_shortcut = "模块快捷方式",
            module_reset_data = "重置模块位置/大小",
            module_shortcut_info = [[
                您可以通过控制台和聊天命令快速访问此GmodAdminSuite模块。

                通过控制台访问模块，请输入：%s
                通过聊天访问模块，请输入：%s

                此外，您可以将键盘上的键绑定到特定模块。
                要做到这一点，请在控制台中输入：%s

                请确保将KEY替换为您选择的键盘上的键。
            %s]],
            close = "关闭",
            wiki = "维基",
            licensee = "许可证持有者",
            support = "支持",
            module_shop = "模块商店",
            welcome = "欢迎",
            operator = "操作员",
            script_page = "脚本页面",
            no_modules_available = "没有可用的模块！",
            no_modules_available_info = [[
                对不起，没有可供您使用的GmodAdminSuite模块。
		        您可能没有足够的权限使用任何模块，或者没有启用任何模块。
            ]],
            custom_ellipsis = "自定义...",
            usergroup_ellipsis = "用户组...",
            steamid_ellipsis = "SteamID...",
            enter_steamid_ellipsis = "输入SteamID...",
            by_distance = "按距离",
            by_usergroup = "按用户组",
            by_team = "按团队",
            by_name = "按名称",
            right_click_to_focus = "右键点击聚焦",
            unknown = "未知",
            utilities = "实用工具",
            player_management = "玩家管理",
            administration = "管理",
            s_second = "1秒",
            s_seconds = "%d秒",
            s_minute = "1分钟",
            s_minutes = "%d分钟",
            s_hour = "1小时",
            s_hours = "%d小时",
            second_ago = "1秒前",
            seconds_ago = "%d秒前",
            minute_ago = "1分钟前",
            minutes_ago = "%d分钟前",
            hour_ago = "1小时前",
            hours_ago = "%d小时前",
            just_now = "刚刚",
            click_to_focus = "点击聚焦",
            add_steamid = "自定义SteamID",
            copied = "已复制！",
            settings = "设置",
            add_steamid_help = [[
                输入SteamID或SteamID64。例如：
                SteamID：%s
                SteamID64：%s
            ]],

            setting_default_module = "默认模块",
            setting_default_module_tip = "打开GmodAdminSuite主菜单时应打开哪个模块？",
            none = "无",
            general = "通用",
            localization = "本地化",
            setting_menu_voicechat = "打开GAS菜单时允许语音聊天",
            setting_menu_voicechat_tip = "GmodAdminSuite的菜单不会阻止您的语音聊天键。如果此选项开启，只需按下您的语音聊天键即可在菜单中进行交谈。",
            use_gas_language = "使用GmodAdminSuite语言",
            default_format = "默认格式",
            short_date_format = "短日期格式",
            long_date_format = "长日期格式",
            short_date_format_tip = "用于较短日期格式的日期格式\n\n默认格式会自动匹配您所在地区的日期格式（北美、欧洲等）",
            long_date_format_tip = "用于较长日期格式的日期格式",
            permissions = "权限",
            module_enable_switch_tip = "此更改只会在服务器重启/地图更改后应用",
            enabled = "已启用",
            modules = "模块",
            permissions_help = [[
                GmodAdminSuite使用了一个名为OpenPermissions的开源权限库，由Billy为GAS开发。它为任何大小的服务器上运行的高级系统提供了优化的权限处理。
		
                OpenPermissions是您将控制哪些组可以访问哪些模块以及他们可以对这些模块做什么的地方。
                您可以随时通过在聊天中输入"!openpermissions"或在控制台中输入"openpermissions"来打开它。

                需要帮助和信息，请点击OpenPermissions菜单中的"帮助"标签。
            ]],
            website = "网站",
            fun = "权限",

            bvgui_copied = "已复制！",
            bvgui_open_context_menu = "打开上下文菜单",
            bvgui_open_steam_profile = "打开Steam个人资料",
            bvgui_right_click_to_focus = "右键点击聚焦",
            bvgui_click_to_focus = "点击聚焦",
            bvgui_unknown = "未知",
            bvgui_no_data = "无数据",
            bvgui_no_results_found = "未找到结果",
            bvgui_done = "完成",
            bvgui_enter_text_ellipsis = "输入文本...",
            bvgui_loading_ellipsis = "加载中...",
            bvgui_pin_tip = "按ESC再次点击菜单",
            bvgui_click_to_render = "点击渲染",
            bvgui_teleport = "传送",
            bvgui_inspecting = "检查中",
            bvgui_inspect = "检查",
            bvgui_screenshot = "截图",
            bvgui_ok = "确定",
            bvgui_screenshot_saved = "截图已保存",
            bvgui_screenshot_saved_to = "截图已保存到您的电脑上的%s",
            bvgui_reset = "重置",
            bvgui_right_click_to_stop_rendering = "右键点击停止渲染",

            settings_player_popup_close = "当\n他们失去焦点时关闭玩家弹窗",
            settings_player_popup_close_tip = "当您点击不同菜单时，玩家弹窗是否应该关闭？"
        }
    end
}
