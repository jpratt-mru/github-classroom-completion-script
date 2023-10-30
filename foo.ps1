# Query a GitHub organization for all commits in all repositories. Use a personal access token with admin:org scope enabled.
# This script uses GitHub CLI (cli.github.com) since it handles pagination nicely.

# Organization to query
$org = "MRU-MACO-1701-004-202304"

# Date of earliest commit in YYYY-MM-DDTHH:MM:SSZ format
$date = "2023-09-25T00:00:00Z"

$lab = "lab-12"

# Get all organization repositories and store them in an array
$repos = gh api --paginate orgs/$org/repos | ConvertFrom-Json # https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#list-organization-repositories



# $repos.full_name is in the format [org]/[repo_name] so can be used to form subsequent API requests
foreach ($repo in $repos.full_name) {
	# Write-Host $repo
	if ($repo -contains $lab){
		Write-Host $repo

	}
    # Loop through each repository and get a list of branches
  
    $branches = gh api --paginate repos/$repo/branches/main | ConvertFrom-Json # https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#list-branches
    
    foreach ($branch in $branches) {

        # Loop through each branch and get a list of commits
        # Write-Host "`t" $repo - $branch.name
        
        # PowerShell doesn't like the & character used inline, so save as a variable first, then form the API query
        $sha = $branch.commit.sha
        # $endpoint = "repos/$repo/commits?sha=$sha&since=$date" # https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#list-commits
		$endpoint = "repos/$repo/commits?since=$date"
        $commits = gh api --paginate $endpoint | ConvertFrom-Json
        
        foreach ($commit in $commits) {

            # Loop through each commit and extract the required data, which could be exported to CSV for filtering
            # Write-Host "`t`t" $repo
			# Write-Host "`t`t" $commit.sha
            # Write-Host "`t`t" $commit.author.login
            # Write-Host "`t`t" $commit.commit.author.date
            # Write-Host ""
        }
    }
}