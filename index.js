const http = require('http');
const Router = require('router');
const Cobol = require('cobol');
const qs = require('querystring');
const buff = require('buffer');
const finalhandler = require('finalhandler');
const path = require('path');
const ejs = require('ejs');
const fs = require('fs');
const fsp = require('fs').promises;
const router = Router();
const cobolStaticDir = path.join(__dirname, 'cobol');
const staticDir = path.join(__dirname,'static');


router.get('/', async (req,res) => {
  res.setHeader('Content-Type','text/html');
  let file =  await ejs.renderFile(path.join(staticDir, 'home.ejs'), {} , undefined);
  res.write(file);
  res.end();
});

router.get('/dailytxn', (req,res) => {
  const filename = 'Practica2ArchivoSec.cbl';
  Cobol(
    path.join(cobolStaticDir, filename), 
    {
//      cwd: cobolStaticDir,
    }, 
    async function (err,data, stderr) {
      res.setHeader('Content-Type','text/html');
      let snippet = await fsp.readFile(path.join(cobolStaticDir,filename));
      let title = "Reporte de transacciones diarias";
      let form = null;
      let file =  await ejs
          .renderFile(path.join(staticDir, 'index.ejs'), 
		  { title, snippet ,executesnap: data , form}, undefined);
      res.write(file);
      res.end();
    }
  );
});

router.get('/atm', (req,res) => {
  const filename = 'Practica2Sesion5.cbl';
  Cobol(
    path.join(cobolStaticDir, filename), 
    {
 //     cwd: cobolStaticDir,
      compileargs : {
        free: true
      }
    }, 
    async function (err,data) {
      console.log('data');
      console.log(data);
      res.setHeader('Content-Type','text/html');
      let snippet = await fsp.readFile(path.join(cobolStaticDir,filename));
      let title = "ATM";
      let form = null;
      let file =  await ejs
          .renderFile(path.join(staticDir, 'index.ejs'), 
		  { title, snippet ,executesnap: data , form}, undefined);
      res.write(file);
      res.end();
    }
  );
})

router.get('/sql/sel', async (req,res) => {
    const filename = 'Practica2-2Sesion6.cbl';
    res.setHeader('Content-Type','text/html');
    let snippet = await fsp.readFile(path.join(cobolStaticDir,filename));
    let title = "Seleccion de un registro en la tabla cuenta";
    let form = {
      inputs : []
    };
    form.inputs.push({ "name": "dni", type: "number" })
    form.inputs.push({ "name": "account", type: "number" })
    let file =  await ejs
          .renderFile(path.join(staticDir, 'index.ejs'), 
		  { title, snippet ,executesnap: "" , form}, undefined);
    res.write(file);
    res.end();
});
router.post('/sql/sel', (req,res) => {
    const filename = 'Practica2-2Sesion6.cbl';
    let body = '';
    req.on('data', (data) => { body += data.toString();});
    req.on('end', async () => {
      let postr = qs.parse(body);
      const filename = 'Practica2-2Sesion6.cbl';
      let snippet = await fsp.readFile(path.join(cobolStaticDir,filename));
      let title = "Seleccion de un registro en la tabla cuenta";
      let form = {
        inputs : []
      };
      form.inputs.push({ "name": "dni", type: "number" })
      form.inputs.push({ "name": "account", type: "number" })
      require('child_process')
          .exec(path.join(cobolStaticDir, 'Practica2-2Sesion6')
        	.concat(` ${postr.dni.toString().padStart(8,'0')} ${postr.account.toString().padStart(10,'0')}`), 
      async function (err, stdout, stderr) {
        let file =  await ejs
          .renderFile(path.join(staticDir, 'index.ejs'), 
		  { title, snippet ,executesnap: stdout , form}, undefined);
        res.setHeader('Content-Type','text/html');
        res.write(file);
        res.end();
      })
    });
    
});

router.get('/sql/ins', async (req,res) => {
    const filename = 'Practica2-1Sesion6.cbl';
    res.setHeader('Content-Type','text/html');
    let snippet = await fsp.readFile(path.join(cobolStaticDir,filename));
    let title = "Insercion de un registro en la tabla cuenta";
    let form = {
      inputs : []
    };
    form.inputs.push({ "name": "dni", type: "number" })
    form.inputs.push({ "name": "account", type: "number" })
    form.inputs.push({ "name": "indicator", type: "text" })
    form.inputs.push({ "name": "salary", type: "number" })
    form.inputs.push({ "name": "saltext", type: "number" })
    form.inputs.push({ "name": "datealt", type: "date" })
    form.inputs.push({ "name": "desc", type: "text" })
    let file =  await ejs
          .renderFile(path.join(staticDir, 'index.ejs'), 
		  { title, snippet ,executesnap: "" , form}, undefined);
    res.write(file);
    res.end();
});

router.post('/sql/ins', (req,res) => {
    const filename = 'Practica2-1Sesion6.cbl';
    let body = '';
    req.on('data', (data) => { body += data.toString();});
    req.on('end', async () => {
      let postr = qs.parse(body);
      let snippet = await fsp.readFile(path.join(cobolStaticDir,filename));
      let title = "Seleccion de un registro en la tabla cuenta";
      let form = {
        inputs : []
      };
    form.inputs.push({ "name": "dni", type: "number" })
    form.inputs.push({ "name": "account", type: "number" })
    form.inputs.push({ "name": "indicator", type: "text" })
    form.inputs.push({ "name": "salary", type: "number" })
    form.inputs.push({ "name": "saltext", type: "number" })
    form.inputs.push({ "name": "datealt", type: "date" })
    form.inputs.push({ "name": "desc", type: "text" })
      require('child_process')
          .exec(path.join(cobolStaticDir, 'Practica2-1Sesion6')
        	.concat(` ${postr.dni.toString().padStart(8,'0')} ${postr.account.toString().padStart(10,'0')} ${postr.indicator.substring(0,1)} ${postr.salary.padStart(10,'0')} ${postr.saltext.padStart(10,'0')} ${postr.datealt} ${postr.desc}`), 
      async function (err, stdout, stderr) {
        let file =  await ejs
          .renderFile(path.join(staticDir, 'index.ejs'), 
		  { title, snippet ,executesnap: stdout , form}, undefined);
        res.setHeader('Content-Type','text/html');
        res.write(file);
        res.end();
      })
    });
});

router.get('/sql/upd', async (req,res) => {
    const filename = 'Practica2-3Sesion6.cbl';
    res.setHeader('Content-Type','text/html');
    let snippet = await fsp.readFile(path.join(cobolStaticDir,filename));
    let title = "Insercion de un registro en la tabla cuenta";
    let form = {
      inputs : []
    };
    form.inputs.push({ "name": "newdni", type: "number" })
    form.inputs.push({ "name": "newaccount", type: "number" })
    form.inputs.push({ "name": "salary", type: "number" })
    form.inputs.push({ "name": "olddni", type: "number" })
    form.inputs.push({ "name": "oldaccount", type: "number" })
    let file =  await ejs
          .renderFile(path.join(staticDir, 'index.ejs'), 
		  { title, snippet ,executesnap: "" , form}, undefined);
    res.write(file);
    res.end();
});
router.post('/sql/upd', async (req,res) => {
    const filename = 'Practica2-3Sesion6.cbl';
    res.setHeader('Content-Type','text/html');
    let snippet = await fsp.readFile(path.join(cobolStaticDir,filename));
    let title = "Insercion de un registro en la tabla cuenta";
    let form = {
      inputs : []
    };
    form.inputs.push({ "name": "newdni", type: "number" })
    form.inputs.push({ "name": "newaccount", type: "number" })
    form.inputs.push({ "name": "salary", type: "number" })
    form.inputs.push({ "name": "olddni", type: "number" })
    form.inputs.push({ "name": "oldaccount", type: "number" })
    let body = '';
    req.on('data', (data) => { body += data.toString();});
    req.on('end', async () => {
      let postr = qs.parse(body);
      require('child_process')
          .exec(path.join(cobolStaticDir, 'Practica2-3Sesion6')
        	.concat(` ${postr.newdni.toString().padStart(8,'0')} ${postr.newaccount.toString().padStart(10,'0')} ${postr.salary.padStart(10,'0')} ${postr.olddni.toString().padStart(8,'0')} ${postr.oldaccount.toString().padStart(10, '0')} `), 
      async function (err, stdout, stderr) {
        let file =  await ejs
          .renderFile(path.join(staticDir, 'index.ejs'), 
		  { title, snippet ,executesnap: stdout , form}, undefined);
        res.setHeader('Content-Type','text/html');
        res.write(file);
        res.end();
      })});
    });

const app = http.createServer((req,res) => {
  if(req.url.match("\.css$")){
    var cssPath = path.join(__dirname, 'static', req.url);
    var fileStream = fs.createReadStream(cssPath, "UTF-8");
    res.writeHead(200, {"Content-Type": "text/css"});
    fileStream.pipe(res);
  } else {
    router(req,res, finalhandler(req,res));
  }
});

const PORT = 4002;

app.listen(PORT);

console.log("Server Application initialized on port " + PORT);

