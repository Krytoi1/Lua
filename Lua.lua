print("yaicawings loaded.")

local secondary_color_original = { r = 255, g = 200, b = 255 }
hit_logs = {}

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

function on_player_hit(damage, bone)
    table.insert(hit_logs, {
        text = "Hit: " .. damage .. " on " .. bone,
        time = os.clock(),
        alpha = 255,
        y_offset = 0
    })

    if #hit_logs > 10 then
        table.remove(hit_logs, 1)
    end
end

function draw_gradient_text(x, y, text, alpha)
    local text_size = calculate_text_size({ text })
    local w = text_size[1]

    for i = 0, w do
        local t = i / w
        local r = math.floor(255 * (1 - t))  
        local g = math.floor(255 * t)        
        local b = 255  

        render_text(x + i, y, text, {r, g, b, alpha}, "c")
    end
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

    -- Рендер хитлогов в стиле Skeet
    local x, y = 50, 400
    local spacing = 20
    local cur_time = os.clock()

    for i = #hit_logs, 1, -1 do
        local log = hit_logs[i]
        local elapsed = cur_time - log.time

        if elapsed > 4 then
            table.remove(hit_logs, i)
        else
            log.alpha = math.max(0, 255 - (elapsed * 255 / 4))  
            log.y_offset = log.y_offset + (1 - elapsed / 4) * 2  

            draw_gradient_text(x, y - log.y_offset - (i * spacing), log.text, log.alpha)
        end
    end
end

