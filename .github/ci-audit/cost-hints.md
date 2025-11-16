# CI Cost Hints for Diatonic-AI/universal-project-template

Failed runs (window): 50

## Longest failing jobs (minutes)
-    0.7m  Analyze (javascript-typescript)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19394575944
-    0.7m  Analyze (javascript-typescript)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19394316855
-   0.68m  Analyze (javascript-typescript)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19394859341
-   0.68m  Analyze (python)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19394859341
-   0.68m  Analyze (javascript-typescript)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19394051579
-   0.65m  Analyze (python)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19402567446
-   0.65m  Analyze (javascript-typescript)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19394576050
-   0.65m  Analyze (python)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19394316855
-   0.65m  Analyze (javascript-typescript)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19394316760
-   0.63m  Analyze (javascript-typescript)  labels=['ubuntu-latest']  run=https://github.com/Diatonic-AI/universal-project-template/actions/runs/19402566365

## Recommendations
- Add concurrency + cancel-in-progress to long-lived workflows (prevents duplicate runs)
- Add on:push paths filters to skip docs-only or non-code changes
- Consider scheduled workflows cadence (weekly/monthly instead of daily)
- Increase cache hit rates (setup-node/setup-python + actions/cache with lockfiles)
- Timeouts: set step/job-level timeouts to prevent runaway costs
- Reduce matrix size or shard by priority (nightly full matrix, PRs minimal)
