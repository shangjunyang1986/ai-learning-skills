<#
  setup-qwen-agent.ps1 — 准备 Qwen-Agent 本地学习环境
  用法:
      ./scripts/setup-qwen-agent.ps1          # DRY-RUN，只打印将要执行的命令，不改动任何东西
      ./scripts/setup-qwen-agent.ps1 -Run     # 真正执行：建 venv + pip 安装 qwen-agent[全功能]

  设计为安全默认：不加 -Run 绝不动手。Qwen-Agent 是纯 pip 包，无需克隆即可起步。
#>
param(
    [switch]$Run,                                              # 不加 = dry-run
    [string]$Dest = (Join-Path (Get-Location) "qwen-agent-lab"),
    [string]$Extras = "gui,rag,code_interpreter,mcp"           # 想最小起步可改成空字符串
)

$ErrorActionPreference = 'Stop'
$mode = if ($Run) { "执行模式 (-Run)" } else { "DRY-RUN 预览（加 -Run 才真正执行）" }
$pkg  = if ($Extras) { "qwen-agent[$Extras]" } else { "qwen-agent" }

Write-Host ""
Write-Host "==================== Qwen-Agent 安装脚本 ====================" -ForegroundColor Cyan
Write-Host "  模式 : $mode"
Write-Host "  目标 : $Dest"
Write-Host "  安装 : $pkg"
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""

# 将要执行的步骤（PyPI 安装，无需 clone；若想读源码再 git clone 仓库）
$steps = @(
    @{ desc = "创建工作目录 $Dest";          cmd = "New-Item -ItemType Directory -Force `"$Dest`" | Out-Null" },
    @{ desc = "创建虚拟环境 (.venv)";          cmd = "python -m venv `"$Dest/.venv`"" },
    @{ desc = "升级 pip";                       cmd = "& `"$Dest/.venv/Scripts/python.exe`" -m pip install -U pip" },
    @{ desc = "安装 $pkg";                      cmd = "& `"$Dest/.venv/Scripts/python.exe`" -m pip install -U `"$pkg`"" }
)

$i = 0
foreach ($s in $steps) {
    $i++
    Write-Host "[$i/$($steps.Count)] $($s.desc)" -ForegroundColor Yellow
    Write-Host "      $ $($s.cmd)" -ForegroundColor DarkGray
    if ($Run) {
        try {
            Invoke-Expression $s.cmd
            Write-Host "      OK 完成" -ForegroundColor Green
        } catch {
            Write-Host "      X 失败: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "      停止。请把上面的报错回填到学习手册第 8 节『踩坑日志』。" -ForegroundColor Red
            exit 1
        }
    }
    Write-Host ""
}

Write-Host "===========================================================" -ForegroundColor Cyan
if ($Run) {
    Write-Host "安装完成。下一步（跑官方最小示例：自定义工具 + Assistant）：" -ForegroundColor Green
} else {
    Write-Host "以上为预览。确认无误后执行：  ./scripts/setup-qwen-agent.ps1 -Run" -ForegroundColor Green
}
Write-Host @"
    `$env:DASHSCOPE_API_KEY="<你的 DashScope key>"   # 或改用 vLLM/Ollama 的 OpenAI 兼容端点
    # 读源码 / 跑官方 examples 可再克隆仓库：
    git clone https://github.com/QwenLM/Qwen-Agent.git
    & "$Dest/.venv/Scripts/python.exe" Qwen-Agent/examples/assistant_qwen3.py
"@
Write-Host ""
