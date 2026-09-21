# GitHub Repository Controls

The workflow enforces plan-only behavior for non-main branches. GitHub repository settings must enforce the remaining merge controls because branch protection cannot be defined by the Terraform workflow itself.

## Required `main` Branch Rules

- Require a pull request before merging.
- Require at least two platform-owner approvals for production infrastructure.
- Require CODEOWNERS review for `.github/`, `*.tf`, `modules/`, and `environments/`.
- Require the `Format and validate`, `DevSecOps checks`, `Plan nonprd`, and `Plan prd` checks.
- Dismiss stale approvals when the branch changes.
- Require branches to be up to date before merging.
- Restrict pushes and prevent force pushes and branch deletion.
- Restrict workflow file changes to approved platform maintainers.

## Production Break-Glass

`ALLOW_DESTRUCTIVE_CHANGES` defaults to `false`. Setting it to `true` is an exception process and must be limited to the protected plan environments, approved by the platform owner, and recorded in the pull request. Deletes and replacements are blocked by default.

## Supply Chain

GitHub Actions are pinned to commit SHAs in the workflow. Dependabot tracks new action releases through `.github/dependabot.yml`; action upgrades must pass the same security and Terraform checks.
