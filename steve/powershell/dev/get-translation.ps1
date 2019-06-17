CLS

# $Translation = Invoke-WebRequest "http://baidu.com/"

# $Translation = Invoke-WebRequest "https://youdao.com/w/eng/hello%20world/#keyfrom=dict2.index"
$Translation = Invoke-RestMethod "https://youdao.com/w/pixel/#keyfrom=dict2.top"

# $Test = Invoke-RestMethod "http://baidu.com/"

$Translation