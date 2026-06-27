<#
  setup-omagent.ps1 — 把 OmAgent 拉到本地并准备运行环境
  用法:
      ./scripts/setup-omagent.ps1          # DRY-RUN，只打印将要执行的命令，不改动任何东西
      ./scripts/setup-omagent.ps1 -Run     # 真正执行：clone + 建 venv + 安装 omagent-core

  设计为安全默认：不加 -Run 绝不动手。
#>
param(
    [switch]$Run,                                   # 不加 = dry-run
    [string]$Dest = (Join-Path (Get-Location) "OmAgent"),
    [string]$Repo = "https://github.com/om-ai-lab/OmAgent.git"
)

$ErrorActionPreference = 'Stop'
$mode = if ($Run) { "执行模式 (-Run)" } else { "DRY-RUN 预览（加 -Run 才真正执行）" }

Write-Host ""
Write-Host "==================== OmAgent 安装脚本 ====================" -ForegroundColor Cyan
Write-Host "  模式 : $mode"
Write-Host "  目标 : $Dest"
Write-Host "  仓库 : $Repo"
Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host ""

# 将要执行的步骤
$steps = @(
    @{ desc = "克隆仓库到 $Dest";              cmd = "git clone --depth 1 $Repo `"$Dest`"" },
    @{ desc = "创建虚拟环境 (.venv)";          cmd = "python -m venv `"$Dest/.venv`"" },
    @{ desc = "升级 pip";                       cmd = "& `"$Dest/.venv/Scripts/python.exe`" -m pip install -U pip" },
    @{ desc = "安装 omagent-core";              cmd = "& `"$Dest/.venv/Scripts/python.exe`" -m pip install omagent-core" }
)

$i = 0
foreach ($s in $steps) {
    $i++
    Write-Host "[$i/$($steps.Count)] $($s.desc)" -ForegroundColor Yellow
    Write-Host "      $ $($s.cmd)" -ForegroundColor DarkGray

    if ($Run) {
        if ($i -eq 1 -and (Test-Path $Dest)) {
            Write-Host "      目标目录已存在，跳过 clone。" -ForegroundColor Magenta
            continue
        }
        try {
            Invoke-Expression $s.cmd
            Write-Host "      ✓ 完成" -ForegroundColor Green
        } catch {
            Write-Host "      ✗ 失败: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "      停止。请把上面的报错回填到学习手册第 8 节『踩坑日志』。" -ForegroundColor Red
            exit 1
        }
    }
    Write-Host ""
}

Write-Host "=========================================================" -ForegroundColor Cyan
if ($Run) {
    Write-Host "安装完成。下一步（跑最小示例 SimpleVQA）：" -ForegroundColor Green
} else {
    Write-Host "以上为预览。确认无误后执行：  ./scripts/setup-omagent.ps1 -Run" -ForegroundColor Green
}
Write-Host @"
    cd "$Dest/examples/step1_simpleVQA"
    `$env:custom_openai_key="<你的key>"
    `$env:custom_openai_endpoint="<你的endpoint>"
    & "$Dest/.venv/Scripts/python.exe" compile_container.py
    & "$Dest/.venv/Scripts/python.exe" run_webpage.py   # 打开 http://127.0.0.1:7860
"@
Write-Host ""
