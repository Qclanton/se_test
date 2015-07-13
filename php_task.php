<?php
$file = file("test_data.txt");
$data = array_map(
	function($row) {
		list ($id, $date, $time) = explode(" ", trim($row));
		return ['id'=>$id, 'datetime'=>"{$date} {$time}"];
	}, 
	file("test_data.txt")
);

usort($data, function($some_row, $other_row) {
	if ($some_row['id'] != $other_row['id']) {
		return ($some_row['id'] > $other_row['id']) ? 1 : -1;
	}
	else {
		return (strtotime($some_row['datetime']) >= strtotime($other_row['datetime'])) ? 1 : -1;
	}
});


foreach ($data as $row) {
	file_put_contents("test_output.txt", "{$row['id']} {$row['datetime']}" . PHP_EOL, FILE_APPEND | LOCK_EX);
}
?>
