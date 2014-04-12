# -*- coding: utf-8 -*-

Plugin.create(:mikutter_oshiri_turbo) do

    FILE = File.join(File.dirname(__FILE__), "otp.dat")
    
    otp = 0

    if File.exist?(FILE)
        File.open(FILE) do |f|
            otp = f.gets.to_i
        end
    end
    
    on_favorite do |service, fav_by, message|
        if fav_by[:idname] != service.idname
            got_otp = rand(30) + 1
            if fav_by[:idname] == "firstspring1845"
                got_otp = got_otp * 1.845
            end
            otp = otp + got_otp
        end
    end

    command(:check_oshiri_turbo_point,
        name: "おしりターボポイントの確認",
        condition: lambda{ |opt| true },
        visible: false,
        role: :window) do 
        activity :system, "現在のおしりターボポイントは #{otp} です。"
    end

    command(:oshiri_turbo,
        name: "おしりターボ",
        condition: lambda{ |opt| true },
        visible: false,
        role: :window) do
        turbo = 0.0
        used_otp = 0
        while otp > 0 do
            otp = otp - 1
            used_otp = used_otp + 1
            
            turbo = turbo + (rand(1835).to_f / 1000 + 0.001)
        end
        message = "#{used_otp}OTPを使い、おしりターボした結果は #{turbo} cm でした。 #ostb_game"
        Service.primary.update(:message => message)
    end

    at_exit do
        File.open(FILE, "w") do |f|
            f.write(otp)
        end
    end
end
