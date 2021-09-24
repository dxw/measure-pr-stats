# Measure PR stats

A script for measuring stats on GitHub PRs.

## How it works

We use [Octokit](https://github.com/octokit/octokit.rb) to access the GitHub API, and the generate stats about all the pull requests in a repository.

## Usage

### Setup

`bundle install`

### Run

`ruby get-pr-commits.rb -r dxw/your-repo`

| Option                        | Description           | Options                           | Default   |
| ----------------------------- | --------------------- | ----------------------------------|-----------|
| `-r` or `--repo`              | Repository            | GitHub URL or 'user/repo'         |           |
| `--start` or `--start-date`   | Start date            | `2021-09-24`                      |           |
| `--end` or `--end-date`       | End date              | `2021-09-24`                      |           |
| `--state`                     | PR state              | 'open' or 'closed'                | 'open'    |
| `--draft`                     | Include draft PRs?    | `true` or `false`                 | `false`   |
| `--bots`                      | Include bots?         | `true` or `false`                 | `false`   |
| `--token`                     | GitHub access token   |                                   |           |

You can provide a GitHub access token through the option flag listed above, or by specifing it in `.env`.

A JSON file will be created in `output/`. The structure is:

```
{
    "2021-09": [
        {
            "url": "https://api.github.com/repos/dxw/rails-template/pulls/277",
            "prn": 277,
            "created_at": "2021-09-03 14:26:13 UTC",
            "closed_at": "2021-09-06 08:46:33 UTC",
            "number_of_commits": 1,
            "number_of_files": 1,
            "number_of_reviewers": 3,
            "number_of_comments": 2,
            "avg_commit_message_word_count": 6,
            "total_lines_added": 16,
            "total_lines_deleted": 0,
            "total_lines_changed": 16,
            "pr_message_word_count": 46
        }
    ],
    "2021-07": [
        {
            "url": "https://api.github.com/repos/dxw/rails-template/pulls/261",
            "prn": 261,
            "created_at": "2021-07-23 16:41:52 UTC",
            "closed_at": "2021-09-03 11:25:26 UTC",
            "number_of_commits": 6,
            "number_of_files": 10,
            "number_of_reviewers": 3,
            "number_of_comments": 0,
            "avg_commit_message_word_count": 30,
            "total_lines_added": 29,
            "total_lines_deleted": 1,
            "total_lines_changed": 30,
            "pr_message_word_count": 197
        }
    ]   
}
```