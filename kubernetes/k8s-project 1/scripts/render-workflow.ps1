# Regenerate the README animation using Windows System.Drawing; no dependencies.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$outputPath = Join-Path $PSScriptRoot '../docs/deployment-workflow.gif'
$steps = @('Validate', 'Review plan', 'VPC + EKS', 'IAM / IRSA', 'Helm services', 'Verify')
$details = @(
    'Initialize providers and validate Terraform configuration.',
    'Inspect proposed changes before approving terraform apply.',
    'Provision networking, the EKS control plane and worker nodes.',
    'Bind Kubernetes service accounts to scoped AWS IAM roles.',
    'Install NGINX Ingress, cert-manager and external-dns.',
    'Check nodes, pods and services with kubectl.'
)
$stream = [System.IO.MemoryStream]::new()
$writer = [System.IO.BinaryWriter]::new($stream)
$font = [System.Drawing.Font]::new('Segoe UI', 13)
$titleFont = [System.Drawing.Font]::new('Segoe UI', 23, [System.Drawing.FontStyle]::Bold)
try {
    for ($step = 0; $step -lt $steps.Count; $step++) {
        $bitmap = [System.Drawing.Bitmap]::new(1040, 300)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.Clear([System.Drawing.Color]::FromArgb(15, 23, 42))
        $graphics.DrawString('EKS LAB  /  DEPLOYMENT WORKFLOW', $titleFont, [System.Drawing.Brushes]::White, 28, 22)
        $graphics.DrawString('Terraform + AWS + Helm   |   us-east-1', $font, [System.Drawing.Brushes]::LightGray, 30, 68)
        for ($i = 0; $i -lt $steps.Count; $i++) {
            $x = 28 + $i * 169
            $brush = if ($i -eq $step) { [System.Drawing.Brushes]::Teal } else { [System.Drawing.Brushes]::DarkSlateGray }
            $graphics.FillRectangle($brush, $x, 120, 145, 68)
            $graphics.DrawString("$($i + 1). $($steps[$i])", $font, [System.Drawing.Brushes]::White, $x + 8, 142)
            if ($i -lt 5) { $graphics.DrawString('>', $font, [System.Drawing.Brushes]::LightGray, $x + 150, 142) }
        }
        $graphics.DrawString($details[$step], $font, [System.Drawing.Brushes]::White, 30, 219)
        $graphics.DrawString('Conceptual stages; Terraform schedules resources from its dependency graph.', $font, [System.Drawing.Brushes]::LightGray, 30, 258)
        $frame = [System.IO.MemoryStream]::new()
        $bitmap.Save($frame, [System.Drawing.Imaging.ImageFormat]::Gif)
        $bytes = $frame.ToArray()
        $paletteSize = 3 * [int][Math]::Pow(2, (($bytes[10] -band 7) + 1))
        if ($step -eq 0) {
            $writer.Write([System.Text.Encoding]::ASCII.GetBytes('GIF89a'))
            $writer.Write($bytes, 6, 7 + $paletteSize)
            # NETSCAPE loop extension: repeat indefinitely.
            $writer.Write([byte[]]@(33,255,11))
            $writer.Write([System.Text.Encoding]::ASCII.GetBytes('NETSCAPE2.0'))
            $writer.Write([byte[]]@(3,1,0,0,0))
        }
        # Delay 160 centiseconds; retain each fully painted frame.
        $writer.Write([byte[]]@(33,249,4,4,160,0,0,0))
        $position = 13 + $paletteSize
        while ($bytes[$position] -eq 33) {
            $position += 2
            while ($bytes[$position] -ne 0) { $position += 1 + $bytes[$position] }
            $position++
        }
        if ($bytes[$position] -ne 44) { throw 'GIF image descriptor missing' }
        $writer.Write($bytes, $position, 9)
        $packed = $bytes[$position + 9]
        $writer.Write([byte](128 -bor ($packed -band 120) -bor ($bytes[10] -band 7)))
        $writer.Write($bytes, 13, $paletteSize)
        $position += 10
        if (($packed -band 128) -ne 0) { throw 'Unexpected local palette' }
        $writer.Write($bytes, $position, $bytes.Length - $position - 1)
        $frame.Dispose()
        $graphics.Dispose()
        $bitmap.Dispose()
    }
    $writer.Write([byte]59)
    [System.IO.File]::WriteAllBytes($outputPath, $stream.ToArray())
    Write-Output "Created $outputPath"
} finally {
    $font.Dispose()
    $titleFont.Dispose()
    $writer.Dispose()
    $stream.Dispose()
}
