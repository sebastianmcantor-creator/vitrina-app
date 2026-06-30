// Render de los 10 posts a PNG 1080x1080 con @resvg/resvg-js
const fs = require('fs');
const path = require('path');
const { Resvg } = require('@resvg/resvg-js');

const INK='#1c1612', CREAM='#f7f2ea', GOLD='#e8c87a', TERRA='#b85a30',
      MUTEDC='#8a7e74', MUTEDW='rgba(247,242,234,.62)';

const POSTS = [
  { name:'01-problema', bg:INK, fg:CREAM, accent:TERRA, kicker:'EL PROBLEMA DE TODO RESTAURANTE',
    lines:['Mientras vos corrés,','Tano ya tomó','el pedido.'],
    sub:'El cliente escanea el QR y pide solo. Sin esperas, sin errores, sin perder ventas.',
    cta:'14 días gratis' },
  { name:'02-que-es', bg:CREAM, fg:INK, accent:TERRA, kicker:'MENÚ DIGITAL CON QR',
    lines:['Tu carta,','ahora atiende','sola.'],
    sub:'Menú con fotos + Tano que responde en español, inglés y portugués. El cliente pide y paga desde la mesa.',
    cta:'Desde $27/mes' },
  { name:'03-cobros', bg:INK, fg:CREAM, accent:'#00a8e8', kicker:'COBROS DESDE LA MESA',
    lines:['Cobrá antes','de que se','levanten.'],
    sub:'Pago con MercadoPago desde la mesa. La plata cae directo a tu cuenta y las mesas rotan más rápido.',
    cta:'vitrinaapp.com.ar' },
  { name:'04-cocina', bg:CREAM, fg:INK, accent:TERRA, kicker:'PANTALLA DE COCINA',
    lines:['La cocina,','sin papelitos.'],
    sub:'El pedido entra y aparece en la pantalla al toque. Sin "¿qué pidió la 4?", sin malentendidos.',
    cta:'14 días gratis' },
  { name:'05-tano', bg:INK, fg:GOLD, accent:GOLD, kicker:'ASISTENTE 24/7',
    lines:['Tano no se','toma franco.'],
    sub:'Responde qué lleva el plato, si hay opción sin TACC, qué recomendás hoy. A cualquier hora, en 3 idiomas.',
    cta:'Tu mejor mozo · $27/mes', subColor:'rgba(232,200,122,.75)' },
  { name:'06-antes-despues', bg:CREAM, fg:INK, accent:TERRA, kicker:'ANTES  /  DESPUÉS',
    lines:['Carta de papel','manchada.','O un QR con','fotos que venden.'],
    sub:'Precios al día en 1 clic. ¿De qué lado está tu restaurante?',
    cta:'vitrinaapp.com.ar' },
  { name:'07-idiomas', bg:INK, fg:CREAM, accent:TERRA, kicker:'MENÚ EN VARIOS IDIOMAS',
    lines:['Tu menú,','en su idioma.'],
    sub:'Llega un turista y lee tu carta en español, inglés o portugués. Automático. Más ventas, cero confusión.',
    cta:'14 días gratis' },
  { name:'08-precio', bg:INK, fg:CREAM, accent:GOLD, kicker:'TODO INCLUIDO',
    lines:[], big:'$27', bigUnit:'/mes',
    sub:'Menú QR, pedidos, cobros, cocina y Tano. Menos que 2 cafés con leche por día.',
    cta:'14 días gratis · sin tarjeta' },
  { name:'09-fotos-ia', bg:CREAM, fg:INK, accent:TERRA, kicker:'FOTOS DE PLATOS CON IA',
    lines:['Se come con','los ojos.'],
    sub:'Sacás la foto con el celu y Vitrina te la mejora: fondo prolijo, look de carta profesional.',
    cta:'vitrinaapp.com.ar' },
  { name:'10-cta', bg:TERRA, fg:'#fff', accent:'#ffe6cf', kicker:'EMPEZÁ HOY',
    lines:['Tu restaurante','empieza a','atender solo.'],
    sub:'Armás tu menú en 10 minutos. Lo probás 14 días gratis. Si no te sirve, no pagás nada.',
    cta:'vitrinaapp.com.ar', ctaStrong:true },
];

function esc(s){return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');}

function buildSVG(p){
  const W=1080,H=1080, cx=540;
  const muted = p.subColor || (p.bg===CREAM ? MUTEDC : MUTEDW);
  let y, body='';
  body += `<text x="${cx}" y="180" text-anchor="middle" font-family="Arial,Helvetica,sans-serif" font-size="26" letter-spacing="6" font-weight="700" fill="${p.accent}">${esc(p.kicker)}</text>`;
  body += `<rect x="${cx-44}" y="208" width="88" height="4" rx="2" fill="${p.accent}"/>`;
  if(p.big){
    body += `<text x="${cx}" y="600" text-anchor="middle" font-family="Georgia,'Times New Roman',serif" font-size="360" font-weight="700" fill="${p.fg}">${esc(p.big)}<tspan font-size="120" fill="${p.accent}">${esc(p.bigUnit||'')}</tspan></text>`;
  } else {
    const fs = p.lines.length>=4 ? 86 : 100;
    const lh = p.lines.length>=4 ? 104 : 120;
    const total=(p.lines.length-1)*lh;
    y = 560 - total/2;
    p.lines.forEach(line=>{
      body += `<text x="${cx}" y="${y}" text-anchor="middle" font-family="Georgia,'Times New Roman',serif" font-size="${fs}" font-weight="700" fill="${p.fg}">${esc(line)}</text>`;
      y += lh;
    });
  }
  const words=p.sub.split(' '); let lines=[],cur='';
  words.forEach(w=>{ if((cur+' '+w).trim().length>40){lines.push(cur.trim());cur=w;} else cur+=' '+w; });
  if(cur.trim())lines.push(cur.trim());
  y = p.big ? 720 : 780;
  lines.forEach(l=>{
    body += `<text x="${cx}" y="${y}" text-anchor="middle" font-family="Arial,Helvetica,sans-serif" font-size="32" fill="${muted}">${esc(l)}</text>`;
    y += 44;
  });
  const fy=988, gx=70;
  body += `<g transform="translate(${gx},${fy-22})"><rect x="0" y="0" width="34" height="34" rx="6" fill="none" stroke="${p.fg}" stroke-width="3"/><line x1="17" y1="0" x2="17" y2="34" stroke="${p.fg}" stroke-width="3"/><line x1="0" y1="17" x2="34" y2="17" stroke="${p.fg}" stroke-width="3"/></g>`;
  body += `<text x="${gx+48}" y="${fy+4}" font-family="Georgia,serif" font-size="34" font-weight="700" fill="${p.fg}">Vitrina</text>`;
  const ctaText=p.cta, pad=28;
  const approxW = ctaText.length*15 + pad*2;
  const px = W-70-approxW;
  const fillPill = p.ctaStrong ? p.fg : p.accent;
  const txtPill  = p.ctaStrong ? p.bg : (p.bg===CREAM? '#fff' : INK);
  body += `<rect x="${px}" y="${fy-30}" width="${approxW}" height="52" rx="26" fill="${fillPill}"/>`;
  body += `<text x="${px+approxW/2}" y="${fy+3}" text-anchor="middle" font-family="Arial,Helvetica,sans-serif" font-size="22" font-weight="700" fill="${txtPill}">${esc(ctaText)}</text>`;
  return `<svg xmlns="http://www.w3.org/2000/svg" width="${W}" height="${H}" viewBox="0 0 ${W} ${H}"><rect width="${W}" height="${H}" fill="${p.bg}"/>${body}</svg>`;
}

const outDir = __dirname;
let ok=0;
for(const p of POSTS){
  const svg = buildSVG(p);
  const resvg = new Resvg(svg, { fitTo:{mode:'width',value:1080}, font:{ loadSystemFonts:true } });
  const png = resvg.render().asPng();
  const f = path.join(outDir, p.name+'.png');
  fs.writeFileSync(f, png);
  console.log('✓', p.name+'.png', (png.length/1024|0)+'KB');
  ok++;
}
console.log('LISTO:', ok, 'imagenes en', outDir);
