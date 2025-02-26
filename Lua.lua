print("yaicawings loaded.")

local secondary_color_original = { r = 255, g = 200, b = 255 }

function lerp_color(color1, color2, t)
    return {
        r = color1.r + (color2.r - color1.r) * t,
        g = color1.g + (color2.g - color1.g) * t,
        b = color1.b + (color2.b - color1.b) * t,
    }
end

function pulse(time, speed)
    return 0.5 + 0.5 * math.sin(time * speed)
end

function on_render()
    center_x, center_y = get_screen_center()

    text_first_w, text_first_h = calculate_text_size("angel")
    text_second_w, text_second_h = calculate_text_size("wings")

    text_full_w = text_first_w + text_second_w
    
    local main_color = { r = 255, g = 255, b = 255 }

    local time = os.clock()

    local pulse_value = pulse(time, 2)

    local secondary_color = lerp_color(secondary_color_original, { r = 255, g = 255, b = 255 }, pulse_value)

    render_rect(center_x - text_full_w * 0.5, center_y + 100 + text_first_h * 0.5, text_full_w, text_first_h * 0.2, main_color, 1 << 1, 20)

    render_text(center_x - text_full_w * 0.5, center_y + 100, 0, 0, main_color, 1 << 0, "angel")
    render_text(center_x - text_full_w * 0.5 + text_first_w, center_y + 100, 0, 0, secondary_color, 1 << 0, "wings")
function on_player_hit(damage, bone)
    table.insert(hit_logs, "Hit: " .. damage .. " on " .. bone)

    if #hit_logs > 10 then
        table.remove(hit_logs, 1)
    end
end 
end
