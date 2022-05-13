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
  let file =  await ejs.renderFile(path.join(staticDir, 'index.ejs'), { data: 'hellow' }, undefined);
  res.write(file);
  res.end();
});

router.get('/dailytxn', (req,res) => {
  const filename = 'Practica2ArchivoSec.cbl';
  Cobol(
    path.join(cobolStaticDir, filename), 
    {
      cwd: cobolStaticDir,
      compileargs : {
        free: true
      }
    }, 
    async function (err,data) {
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
      cwd: cobolStaticDir,
      compileargs : {
        free: true
      }
    }, 
    async function (err,data) {
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
    let title = "Insercion de un registro en la tabla cuenta";
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
      let title = "Insercion de un registro en la tabla cuenta";
      let form = {
        inputs : []
      };
      form.inputs.push({ "name": "dni", type: "number" })
      form.inputs.push({ "name": "account", type: "number" })
      require('child_process')
          .exec(path.join(cobolStaticDir, 'Practica2-2Sesion6')
        	.concat(` ${postr.dni} ${postr.account}`), 
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

router.get('/sql/insert', (req,res) => {
    require('child_process')
        .exec(path.join(cobolStaticDir, 'Practica2-1Sesion6')
	.concat(` 76793291 0004571112 A 10000 2000 2022-01-02 DESCRIPCION`), 
    function (err, stdout, stderr) {
      res.setHeader('Content-Type', 'text/plain');
      res.write(stdout);
      res.write(stderr);
      res.end();
    }
    );
});

router.get('/sql/update', (req,res) => {
  require('child_process')
     .exec(path.join(cobolStaticDir, 'Practica2-3Sesion6')
  	.concat(` 76793291 0002221114 3000000000 76793291 111333221`),
  function(err, stdout, stderr) {
      res.setHeader('Content-Type', 'text/plain');
      res.write(stdout);
      res.write(stderr);
      res.end();
  }
  )
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

