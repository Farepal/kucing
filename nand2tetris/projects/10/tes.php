<?php
$text = 'saya makan "kucing babgi sad" terus "sad sl" sdakjl "asl"';

// Regex untuk memisahkan kata-kata dan teks di dalam tanda kutip
preg_match_all('/"[^"]*"|\S+/', $text, $matches);

// Hasil akhir dalam bentuk array
$result = $matches[0];

// Cetak hasil
print_r($result);
