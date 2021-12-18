const fs = require('fs');

function part_one() {
  fs.readFile("input.txt", "utf-8", (err, data) => {
    if(err) console.error(err);
    let res = 0;
    data.split("\n").forEach(line => {
      const [, str] = line.split(" | ");
      if(str) {
        str.split(" ").forEach(word => {
          const wordLen = word.length;
          if(wordLen == 2 || wordLen == 3 || wordLen == 4 || wordLen == 7) ++res;
        });
      }
    })
    console.log(res);
  });  
}

function part_two() {
  const sortAlphabets = function(text) {
    return text.split('').sort().join('');
  };

  fs.readFile("input.txt", "utf-8", (err, data) => {
    if(err) console.error(err);
    const res = data.split("\n").map(line => {
      if(!line) return 0;

      const freqMap    = {};
      const [txt, str] = line.split(" | ");

      txt.split(" ").forEach(t => {
        const len = t.length;
        if(freqMap[len]) {
          freqMap[len].push(t);
        } else {
          freqMap[len] = [t];
        }
      });

      const UNSORTED_MAP = {};
      UNSORTED_MAP[freqMap[2][0]] = 1;
      UNSORTED_MAP[freqMap[3][0]] = 7;
      UNSORTED_MAP[freqMap[4][0]] = 4;
      UNSORTED_MAP[freqMap[7][0]] = 8;

      let tmb = "";
      const remFives = [];

      freqMap[5].forEach(i => {
        const t = [...i].join("");
        const ones = freqMap[2][0];
        [...ones].forEach(c => {
          i = i.replace(c, "");          
        });
        if(i.length === 3) {
          UNSORTED_MAP[t] = 3;
          tmb = i;
        } else {
          remFives.push(t);
        }
      });

      const cN = new Set([...tmb, ...freqMap[4][0]]);
      const cNN = Array.from(cN).join("");
      let nineSorted = "";
      const remNines = [];

      freqMap[6].forEach(i => {
        const s = sortAlphabets(cNN);
        const sortedI = sortAlphabets(i);
        if(sortedI === s) {
          UNSORTED_MAP[i] = 9;
          nineSorted = sortedI;
        } else {
          remNines.push(i);
        }
      });

      remFives.forEach(i => {
        let replaced = [...nineSorted].join("");
        
        [...i].forEach(c => {
          replaced = replaced.replace(c, "");
        });

        if(replaced.length === 1) {
          UNSORTED_MAP[i] = 5;
        } else {
          UNSORTED_MAP[i] = 2;
        }
      });

      remNines.forEach(i => {
        const t = [...i].join("");
        
        [...freqMap[2][0]].forEach(c => {
          i = i.replace(c, "");
        });

        if(i.length === 4) {
          UNSORTED_MAP[t] = 0;
        } else {
          UNSORTED_MAP[t] = 6;
        }
      });

      const SORTED_MAP = {};
      for (const [key, value] of Object.entries(UNSORTED_MAP)) {
        SORTED_MAP[sortAlphabets(key)] = value;
      }

      if(str) {
        let num = 0;
        str.split(" ").forEach((word, idx) => {
          const wordVal = SORTED_MAP[sortAlphabets(word)];
          if(wordVal === undefined) {
            throw new Error("Unreachable");
          }
          num += ((10 ** (3 - idx)) * wordVal); 
        });
        return num;
      } else {
        return 0;
      }
    }).reduce((a, b) => a + b, 0);

    console.log(res);
  });
}

part_one();
part_two();
