<?php

require "vendor/autoload.php";
\Predis\Autoloader::register();

$redisConfig = array(
    "scheme" => "tcp",
    "host" => "127.0.0.1",
    "port" => 6379
);

function emulateTopKeywords($c) {
    $testData = array(
        array(
            "keywords" => "free+book",
            "score" => 2303
        ),
        array(
            "keywords" => "pretty+picture",
            "score" => 400
        ),
        array(
            "keywords" => "best+seller",
            "score" => 1200
        ),
        array(
            "keywords" => "stuff",
            "score" => 10200
        ),
        array(
            "keywords" => "bedok",
            "score" => 100
        ),
        array(
            "keywords" => "best+seller+free+book",
            "score" => 600
        ),
        array(
            "keywords" => "best+seller",
            "score" => 100
        ),
        array(
            "keywords" => "best+seller",
            "score" => 100
        ),
        array(
            "keywords" => "free+book",
            "score" => 203
        ),

    );

    $sortedSets = "top_keywords";

    if (is_object($c)) {
        try {
            // Delete sorted sets
            /*
            foreach($testData as $d) {
                if ($c instanceOf \Predis\Client) {
                    $c->del($sortedSets);
                } else {
                    $c->delete($sortedSets);
                }
            }*/

            // Iterate thru test data, push to list
            foreach($testData as $d) {
                if ($c instanceOf \Predis\Client) {
                    $c->zincrby($sortedSets, $d["score"], $d["keywords"]);
                } else {
                    $c->zIncrBy($sortedSets, $d["score"], $d["keywords"]);
                }
            }

            foreach($testData as $d) {
                echo "Keyword: ${d["keywords"]}, score:" . $c->zscore($sortedSets, $d["keywords"]) . "\n";
            }
            // Get whatever in the sets
            if ($c instanceOf \Predis\Client) {
                var_dump($c->zrangebyscore($sortedSets, 1, 10000000));
            } else {
                var_dump($c->zRevRangeByScore($sortedSets, "+inf", "-inf", array('withscores' => true, 'limit' => array(0, 4))));
            }
        } catch(Exception $e) {
            echo $e->getMessage();
        }
    }
}

try {
    $start = microtime(true);
    $predis = new \Predis\Client($redisConfig);
    emulateTopKeywords($predis);
    $stop = microtime(true);
    $el = ($stop - $start) * 1000;

    echo "Predis client test elapsed:" . $el . " ms\n";

} catch (Exception $e) {
    var_dump($e->getMessage());
}

try {
    $start = microtime(true);
    $redis = new Redis();
    $redis->connect($redisConfig["host"], $redisConfig["port"]);
    emulateTopKeywords($redis);
    $stop = microtime(true);
    echo "Redis client test elapsed: " . ((float)$stop - (float)$start) * 1000 . " ms\n";
} catch (Exception $e) {
    var_dump($e->getMessage());
}
