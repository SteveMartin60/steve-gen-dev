CLS

#..............................................................................

#..............................................................................

$StopWatch = [Diagnostics.Stopwatch]::StartNew()

$StopWatch.Reset()

$StopWatch.Start()

$IpInfo      = Invoke-RestMethod https://ipinfo.io/json

$StopWatch.Stop()

$StopWatch.ElapsedMilliseconds

$StopWatch