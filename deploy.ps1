param([String]$comment)

write-host "git add *" -foregroundcolor   "cyan"
git add *
write-host "git status" -foregroundcolor   "cyan"
git status

if ($comment -eq "") 
{
    write-host -Nonewline "Please provide a comment!" -foregroundcolor   "red"
    write-host " e.g. .\deploy.ps1 `"funny comment`""
} 
else 
{
    write-host "git commit . -m `$comment" -foregroundcolor   "cyan"
    git commit . -m $comment
    write-host "git status"-foregroundcolor   "cyan"
    git status
    write-host "git push"-foregroundcolor   "cyan"
    git push
}