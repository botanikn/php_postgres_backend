<?php

header("Content-Type: application/json");

// Импорт файла, в котором осуществляется подключение к СУБД
include 'db.php';

// Создание подключения к СУБД
$cn = db_connection();

// Получение текущего URL
$request_uri = $_SERVER['REQUEST_URI'];

// Определение метода обращения
$method = $_SERVER['REQUEST_METHOD'];

// Обработка GET-запроса на эндпоинте /api/bus_find
if ($method == 'GET' && strpos($request_uri, '/api/bus_find') !== false) {
    // Запись в переменные ID откуда и куда
    $from = isset($_GET['from']) ? intval($_GET['from']) : null;
    $to = isset($_GET['to']) ? intval($_GET['to']) : null;

    // Проверка наличия необходимых параметров
    if (is_null($from) || is_null($to)) {
        echo json_encode(["error" => "Параметры 'from' и 'to' обязательны."]);
        exit;
    }

    // Массив под название автобусов
    $available_buses = [];

    // Формирование запросов
    $prequery_from = "SELECT bus_id FROM buses_stops WHERE stop_id = $from";
    $prequery_to = "SELECT bus_id FROM buses_stops WHERE stop_id = $to";

    // Получаем названия остановок
    $query_from = pg_query($cn, "SELECT stop_name FROM stops WHERE id = $from");
    $query_to = pg_query($cn, "SELECT stop_name FROM stops WHERE id = $to");

    if (!$query_from || !$query_to) {
        echo json_encode(["error" => "Ошибка при получении названий остановок."]);
        exit;
    }

    $from_stop_name = pg_fetch_result($query_from, 0, 0);
    $to_stop_name = pg_fetch_result($query_to, 0, 0);

    // Отправляем запросы на сервер
    $result_from = pg_query($cn, $prequery_from);
    $result_to = pg_query($cn, $prequery_to);

    if (!$result_from || !$result_to) {
        echo json_encode(["error" => "Ошибка при получении данных о автобусах."]);
        exit;
    }

    // Добавление подходящих автобусов
    $buses_id = [];
    while ($row = pg_fetch_row($result_from)) {
        $buses_id[] = $row[0];
    }

    while ($row = pg_fetch_row($result_to)) {
        $buses_id[] = $row[0];
    }

    // Оставляем только уникальные значения
    $buses_id = array_unique($buses_id);

    // Получаем информацию о каждом автобусе
    foreach ($buses_id as $bus_id) {
        $query = "SELECT bus_name, stop_name, stop_order, start_time + INTERVAL '15 minutes' * stop_order AS arrival_time 
                  FROM buses_stops 
                  JOIN stops ON buses_stops.stop_id = stops.id 
                  JOIN buses ON buses_stops.bus_id = buses.id 
                  WHERE bus_id = $bus_id 
                  ORDER BY stop_order";

        $result = pg_query($cn, $query);
        if (!$result) {
            continue; // Пропускаем, если ошибка в запросе
        }

        $current_time = time();
        while ($row = pg_fetch_row($result)) {
            if ($row[1] == $from_stop_name) {
                $next_arrivals = getNextArrivalTimes($row[3], 15, 3);
                $available_buses[] = [
                    "bus_name" => $row[0],
                    "next_arrivals" => $next_arrivals,
                    "time" => date('H:i', $current_time)
                ];
            }
        }
    }

    // Формирование ответа
    $response = [
        "from" => $from_stop_name,
        "to" => $to_stop_name,
        "buses" => $available_buses,
    ];

    echo json_encode($response);
}

// Обработка POST запроса на эндпоинте /api/add_route
if ($method == 'POST' && strpos($request_uri, '/api/add_route') !== false) {
    // Выделяем из запроса id автобуса, остановки и её порядок в маршруте
    $bus = isset($_POST['bus']) ? intval($_POST['bus']) : null;
    $stop = isset($_POST['stop']) ? intval($_POST['stop']) : null;
    $order = isset($_POST['order']) ? intval($_POST['order']) : null;

    if (is_null($bus) || is_null($stop) || is_null($order)) {
        echo json_encode(["error" => "Параметры 'bus', 'stop' и 'order' обязательны."]);
        exit;
    }

    // Формирование и отправка запроса на создание новой остановки на пути автобуса
    $query = "INSERT INTO buses_stops (bus_id, stop_id, stop_order) VALUES ($bus, $stop, $order)";
    $result = pg_query($cn, $query);

    if (!$result) {
        echo json_encode(["error" => "Ошибка при добавлении остановки"]);
        exit;
    }

    $select_query = "SELECT bus_name, stop_name, stop_order FROM buses_stops 
                     JOIN stops ON buses_stops.stop_id = stops.id 
                     JOIN buses ON buses_stops.bus_id = buses.id 
                     WHERE bus_id = $bus AND stop_id = $stop";
    $select_result = pg_query($cn, $select_query);

    if (!$select_result) {
        echo json_encode(["error" => "Ошибка при получении данных о добавленной остановке"]);
        exit;
    }

    $row = pg_fetch_row($select_result);
    if ($row) {
        $response = [
            "Автобус" => $row[0],
            "Остановка" => $row[1],
            "Порядок остановки в маршруте" => $row[2]
        ];
        echo json_encode($response);
    } else {
        echo json_encode(["error" => "Ошибка в запросе"]);
    }
}

// Закрываем соединение с базой данных
pg_close($cn);

// Функция для рассчёта расписания автобуса относительно текущего времени
function getNextArrivalTimes($start_time, $interval_minutes, $count) {
    $current_time = time();
    $arrival_times = [];

    $start_timestamp = strtotime($start_time);

    if ($start_timestamp < $current_time) {
        // Считаем, сколько интервалов прошло с начала
        $intervals_passed = floor(($current_time - $start_timestamp) / ($interval_minutes * 60));
        $start_timestamp += ($intervals_passed + 1) * $interval_minutes * 60; // Переход к следующему времени
    }

    // Генерируем следующие три времени
    for ($i = 0; $i < $count; $i++) {
        $arrival_times[] = date('H:i', $start_timestamp + ($i * $interval_minutes * 60));
    }

    return $arrival_times;
}
?>