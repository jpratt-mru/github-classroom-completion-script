$target_repos = gh api --paginate /orgs/MRU-MACO-1701-004-202304/repos | ConvertFrom-Json | ForEach-Object {$_.full_name} | Where ({$_.Contains("asg-3")})
foreach ($repo in $target_repos) {
	$branches = gh api --paginate repos/$repo/branches/main | ConvertFrom-Json # https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#list-branches
    
    foreach ($branch in $branches) {

        # Loop through each branch and get a list of commits
        # Write-Host "`t" $repo - $branch.name
        
        # PowerShell doesn't like the & character used inline, so save as a variable first, then form the API query
        $sha = $branch.commit.sha
        # $endpoint = "repos/$repo/commits?sha=$sha&since=$date" # https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#list-commits
		$endpoint = "repos/$repo/commits"
        $commits = gh api --paginate $endpoint | ConvertFrom-Json
        
        foreach ($commit in $commits) {

			if ($commit.author.login.StartsWith("github")){continue}
            # Loop through each commit and extract the required data, which could be exported to CSV for filtering
            Write-Host "`t`t" $repo
			Write-Host "`t`t" $commit.sha
            Write-Host "`t`t" $commit.author.login
            Write-Host "`t`t" $commit.commit.author.date
            Write-Host ""
        }
    }
}