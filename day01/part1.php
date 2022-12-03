<?php
$elves = explode("\n\n", file_get_contents("php://stdin"));
$calories = array_map(fn($elf) => array_sum(explode("\n", $elf)), $elves);
echo max($calories);

