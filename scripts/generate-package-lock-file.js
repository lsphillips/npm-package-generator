'use strict';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const { exec }     = require('child_process');
const { readFile } = require('fs/promises');

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exec('npm i --silent --package-lock-only', async (error, stdout, stderr) =>
{
	if (error || stderr)
	{
		process.exit(1);
	}
	else
	{
		console.log(JSON.stringify({
			packageLockFile : await readFile('package-lock.json', 'utf8')
		}));
	}
});
