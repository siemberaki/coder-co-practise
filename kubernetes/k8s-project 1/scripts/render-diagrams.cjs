// Regenerate GitHub-compatible diagrams with: node scripts/render-diagrams.cjs
const fs = require('node:fs');
const path = require('node:path');
const out = path.join(__dirname, '..', 'docs');
const escape = s => s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');
function diagram(file, title, nodes, edges, height) {
  const boxes = nodes.map(([id, x, y, label]) => {
    const lines = label.split('|');
    return `<g><rect x="${x}" y="${y}" width="290" height="74" rx="10" fill="#163047" stroke="#38bdf8"/>${lines.map((line,i) => `<text x="${x+145}" y="${y+29+i*22}" text-anchor="middle" fill="#f8fafc" font-family="Arial,sans-serif" font-size="15">${escape(line)}</text>`).join('')}</g>`;
  }).join('');
  const links = edges.map(([a,b,label='']) => {
    const source=nodes.find(n=>n[0]===a), target=nodes.find(n=>n[0]===b);
    const x1=source[1]+145, y1=source[2]+74, x2=target[1]+145, y2=target[2];
    return `<path d="M${x1},${y1} L${x2},${y2}" stroke="#94a3b8" stroke-width="2" fill="none" marker-end="url(#arrow)"/>${label ? `<text x="${(x1+x2)/2+12}" y="${(y1+y2)/2}" fill="#cbd5e1" font-family="Arial,sans-serif" font-size="13">${escape(label)}</text>` : ''}`;
  }).join('');
  const svg=`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 960 ${height}" role="img" aria-labelledby="title"><title id="title">${escape(title)}</title><defs><marker id="arrow" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8" fill="#94a3b8"/></marker></defs><rect width="960" height="${height}" rx="16" fill="#0f172a"/><text x="40" y="45" fill="#f8fafc" font-family="Arial,sans-serif" font-size="25" font-weight="bold">${escape(title)}</text>${links}${boxes}</svg>`;
  fs.writeFileSync(path.join(out,file),svg);
}
diagram('architecture.svg','EKS lab architecture',[
 ['tf',335,85,'Engineer + Terraform CLI|AWS credentials / us-east-1'],
 ['state',20,215,'S3 remote state|eks-tfstate-siema / eks-lab'],
 ['vpc',650,215,'VPC / three Availability Zones|Public + private subnets / one NAT'],
 ['eks',335,345,'EKS control plane / 1.33|API restricted to allowed CIDR'],
 ['nodes',20,475,'Private managed worker nodes|Desired: 1 / scaling: 1 to 2'],
 ['helm',650,475,'Helm provider|AWS EKS token authentication'],
 ['logs',20,605,'CloudWatch control plane logs|API / audit / authenticator'],
 ['services',650,605,'NGINX / cert-manager|external-dns'],
 ['roles',650,735,'OIDC + IRSA roles|Scoped Route 53 permissions'],
 ['zone',650,865,'Existing Route 53 hosted zone|DNS updates / DNS challenges']
],[['tf','state'],['tf','vpc'],['tf','eks'],['vpc','eks'],['eks','nodes'],['eks','helm'],['eks','logs'],['helm','services'],['services','roles'],['roles','zone']],980);
diagram('deployment.svg','Deployment workflow',[
 ['init',335,85,'1. terraform init|Load backend, modules and providers'],
 ['validate',335,215,'2. terraform validate|Check configuration'],
 ['plan',335,345,'3. terraform plan|Review proposed changes'],
 ['apply',335,475,'4. terraform apply|Approve reviewed changes'],
 ['infra',335,605,'5. Provision infrastructure|Networking / EKS / IAM'],
 ['helm',335,735,'6. Install Helm releases|Ingress / certificates / DNS controllers'],
 ['verify',335,865,'7. Verify with kubectl|Check nodes, pods and services']
],[['init','validate'],['validate','plan'],['plan','apply'],['apply','infra'],['infra','helm'],['helm','verify']],980);
diagram('access-recovery.svg','Recover access after a public IP change',[
 ['failure',335,85,'Helm refresh cannot reach EKS|Check public IPv4 and live allowlist'],
 ['changed',20,245,'IP changed|Update my_public_ip_cidr'],
 ['other',650,245,'IP matches allowlist|Check VPN / firewall / DNS / routing'],
 ['plan',20,385,'Plan only the EKS cluster resource|Review the targeted recovery plan'],
 ['apply',20,525,'Apply the saved recovery plan|Wait for cluster-active'],
 ['full',20,665,'Run a full terraform plan|Resume normal deployment workflow']
],[['failure','changed','Yes'],['failure','other','No'],['changed','plan'],['plan','apply'],['apply','full']],790);
