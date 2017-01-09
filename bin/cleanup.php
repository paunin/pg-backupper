<?php
set_time_limit(0);
/**
 * I Would never use php in this project...but strtotime function solves a lot of problems.
 * Please advice (with pull request ;) analog in Go or Python
 */
# php /backupper_bin/cleanup.php "$BACKUP_NAME" "$BACKUP_DIR" "$SAFE_DAYS" "$SAFE_WEEKS" "$SAFE_WEEK_DAY" "$SAFE_MONTHS" "$SAFE_MONTH_DATE"

$backupName = $argv[1];
$backupDir  = $argv[2];

$safeDays      = $argv[3];
$safeWeeks     = $argv[4];
$safeWeekDay   = $argv[5];
$safeMonths    = $argv[6];
$safeMonthDate = str_pad($argv[7], 2, "0", STR_PAD_LEFT);

$backupPrefix = $backupDir . "/" . $backupName . "_";



echo " > Will keep all files from today:";
$todayPatterns = [$backupPrefix . date("Y-m-d_*", strtotime('today'))];
echo "\n   > " . implode("\n   > ", $todayPatterns) . "\n";



$yesterdayPattern = $backupPrefix . date("Y-m-d_*", strtotime('yesterday'));
$yesterdayPatterns = [];
$yesterdayFile     = `find / -wholename '$yesterdayPattern' | sort | tail -n1 | xargs echo -n`;

if ($yesterdayFile) {
    echo " > Will keep 1 file from yesterday:";
    $yesterdayPatterns[] = $yesterdayFile;
    echo "\n   > " . implode("\n   > ", $yesterdayPatterns) . "\n";
} else {
    echo " > No file(s) to keep from yesterday!\n";
}



echo " > Will keep files from last $safeDays days by patterns:";
$safeDaysPatterns = [];
for ($i = 2; $i < $safeDays+1; $i++) {
    $safeDaysPatterns[] = $backupPrefix . date("Y-m-d_*", strtotime("$i days ago"));
}
echo "\n   > " . implode("\n   > ", $safeDaysPatterns) . "\n";




echo " > Will keep files from last $safeWeeks week(s) by patterns for day $safeWeekDay:";
$safeWeeksPatterns = [];
for ($i = 0; $i < $safeWeeks; $i++) {
    $safeWeeksPatterns[] = $backupPrefix . date("Y-m-d_*", strtotime("$safeWeekDay $i weeks ago"));
}
echo "\n   > " . implode("\n   > ", $safeWeeksPatterns) . "\n";




echo " > Will keep files from last $safeMonths month(s) by patterns for date $safeMonthDate:";
$safeMonthsPatterns = [];
for ($i = 0; $i < $safeMonths; $i++) {
    $safeMonthsPatterns[] = $backupPrefix . date("Y-m-{$safeMonthDate}_*", strtotime("$i months ago"));
}
echo "\n   > " . implode("\n   > ", $safeMonthsPatterns) . "\n";


// Yesterday is really special day!
// So we need to make sure non of patterns will try to keep more then required for yesterday
$patterns  = array_merge($todayPatterns, $safeDaysPatterns, $safeWeeksPatterns, $safeMonthsPatterns);
foreach ($patterns as $key => $pattern){
    if (strpos($pattern, $yesterdayPattern) === 0){
        unset ($patterns[$key]);
    }
}
$patterns = array_unique(array_merge($patterns, $yesterdayPatterns));
sort($patterns);

echo " > Final list of patterns I will keep:";
echo "\n   > " . implode("\n   > ", $patterns) . "\n";

$safeFiles = [];
foreach ($patterns as $pattern) {
    exec("find / -wholename '$pattern'", $safeFiles);
}
$safeFiles = array_unique($safeFiles);

echo " > OK! Now will remove all files except this list(files exist in FS):";
if (count($safeFiles)) {
    echo "\n   > " . implode("\n   > ", $safeFiles) . "\n";
} else {
    echo "\n   > <Empty list>\n";
}




exec("find / -wholename '$backupPrefix*'", $allFiles);
$filesToRemove = array_diff($allFiles, $safeFiles);
echo " > Removing:\n";
if (count($filesToRemove)) {
    foreach ($filesToRemove as $fileToRemove) {
        `rm -rf $fileToRemove`;
        echo "   > $fileToRemove\n";
    }
} else {
    echo "   > <Empty list>\n";
}




echo " > Checkpoint: check that we did not remove files which we have to keep:\n";
$wronglyRemoved = [];
foreach ($safeFiles as $safeFile) {
    if (!is_file($safeFile)) {
        $wronglyRemoved[] = $safeFile;
    }
}
if (count($wronglyRemoved) == 0) {
    echo "   > All good!\n";
} else {
    echo "   > !!! ATTENTION !!! We wrongly have removed files:";
    echo "\n     > " . implode("\n   > ", $wronglyRemoved) . "\n";
}


$usageSize = `du -sh $backupDir`;
echo " > Your backups disk usage:\n";
echo "   > $usageSize";