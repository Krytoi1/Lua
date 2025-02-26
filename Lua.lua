hit_logs = {}

max_logs = 10  -- Максимальное количество логов
fade_time = 4   -- Время исчезновения (секунды)

function on_player_hit(damage, bone)
    table.insert(hit_logs, {
        text = string.format("Hit for %d HP [%s]", damage, bone),
        time = os.clock(),
        alpha = 255,
        y_offset = 0
    })

    if #hit_logs > max_logs then
        table.remove(hit_logs, 1)
    end
end

-- Градиентный рендер текста
function draw_gradient_text(x, y, text, alpha)
    local text_size = calculate_text_size({ text })
    local w = text_size[1]

    for i = 0, w do
        local t = i / w
        local r = math.floor(255 * (1 - t))  -- Красный → зелёный
        local g = math.floor(255 * t)        
        local b = 255  -- Голубой остаётся неизменным

        render_text(x + i, y, text, {r, g, b, alpha}, "c")
    end
end

function on_render()
    local x, y = 50, 400
    local spacing = 20
    local cur_time = os.clock()

    for i = #hit_logs, 1, -1 do
        local log = hit_logs[i]
        local elapsed = cur_time - log.time

        if elapsed > fade_time then
            table.remove(hit_logs, i)
        else
            log.alpha = math.max(0, 255 - (elapsed * 255 / fade_time))  -- Плавное исчезновение
            log.y_offset = log.y_offset + (1 - elapsed / fade_time) * 2  -- Анимация движения вверх

            draw_gradient_text(x, y - log.y_offset - (i * spacing), log.text, log.alpha)
        end
    end
end
