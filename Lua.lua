hit_logs = {}  -- Таблица для хранения логов
max_time = 4   -- Время жизни логов (в секундах)

-- Функция обработки попадания
function on_player_hit(damage, bone)
    table.insert(hit_logs, {
        text = string.format("Hit for %d HP [%s]", damage, bone),
        time = os.clock(),  -- Время попадания
        alpha = 255,        -- Прозрачность
        y_offset = 0        -- Смещение по Y для анимации
    })
end

-- Функция для рендера градиентного текста
function draw_gradient_text(x, y, text, alpha)
    local text_size = calculate_text_size({ text })  -- Размер текста
    local w = text_size[1]  -- Ширина текста

    for i = 0, w do
        local t = i / w  -- От 0 до 1
        local r = math.floor(255 * (1 - t))  -- Красный градиент
        local g = math.floor(255 * t)        -- Зелёный градиент
        local b = 255  -- Синий остаётся 255 для красивого эффекта

        render_text(x + i, y, text, { r, g, b, alpha }, "c")  -- Отрисовка градиентного текста
    end
end

-- Основная функция рендера хит-логов
function on_render()
    local start_x, start_y = 50, 400  -- Позиция логов
    local spacing = 20                -- Расстояние между строками
    local cur_time = os.clock()        -- Текущее время

    for i = #hit_logs, 1, -1 do
        local log = hit_logs[i]
        local elapsed = cur_time - log.time

        if elapsed > max_time then
            table.remove(hit_logs, i)  -- Удаляем старые логи
        else
            log.alpha = math.max(0, 255 - (elapsed * 255 / max_time))  -- Плавное исчезновение
            log.y_offset = log.y_offset + (1 - elapsed / max_time) * 2  -- Анимация движения вверх

            -- Рисуем градиентный текст
            draw_gradient_text(start_x, start_y - log.y_offset - (i * spacing), log.text, log.alpha)
        end
    end
end
