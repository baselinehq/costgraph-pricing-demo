# CostGraph PR pricing demo

Change an EC2 instance type or count in `terraform.tfvars`, open a PR, and get a
CostGraph comment with the estimated monthly cost change and cheaper candidates.

This is a **plan-only demo**. The AWS credentials and AMI are deliberately fake.
No AWS account, deployed resources, or cloud spend are required. Do not apply it.
Terraform generates real plans locally; CostGraph supplies real catalog prices.

## Supply your CostGraph API key

1. Create a key in [CostGraph account settings](https://app.costgraph.ai/settings/account/api-keys).
2. Open this repo's **Settings → Secrets and variables → Actions**.
3. Add a repository secret named **`COSTGRAPH_API_KEY`** and paste the key.

The workflow supplies it as `api-key: ${{ secrets.COSTGRAPH_API_KEY }}`. The action
authenticates to CostGraph with `X-API-Key`. No real credential belongs in Git.
GitHub's built-in token writes the PR comment; it is separate from the CostGraph key.

## How the demo works

The workflow checks out the PR's base and head commits, generates a Terraform
JSON plan for each, and passes both to the standalone
[CostGraph pricing action](https://github.com/baselinehq/costgraph-pricing-action).
Comparing planned inventories shows the difference between the branches without
deploying either one. Re-running updates the existing comment.

The candidate list provides an explicit fallback when the recommendations API
fails or returns no compatible alternative. Candidates are priced live and retain
the same region, OS, architecture, purchase type, and at least the same CPU/RAM.
They still need workload compatibility review. Estimates cover compute only,
using 730 runtime hours/month, and exclude negotiated discounts.

Fork and Dependabot PRs are skipped because they do not receive the API secret.
The demo workflow never applies Terraform and never uploads plan artifacts.
