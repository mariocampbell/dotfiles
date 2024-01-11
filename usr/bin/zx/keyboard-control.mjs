#!/usr/bin/env zx

/*
 * arguments options
 * --battery
 * --change
 * --xmobar
*/

$.verbose = false;

/* configs ================================ */
/**
 * Wrapper para determinar la fuente en xmobar
 * @param {string} children
 * @param {number} fn
 * @returns {string}
 * */
const fontWrapper = (children, fn) => `<fn=${fn}>${children}</fn>`

/**
 * Envuelve el texto proporcionado con un formato de color específico.
 *
 * @param {string} children - El texto que se va a envolver con formato de color.
 * @param {string} type - El tipo de color a aplicar. Puede ser uno de: 'white', 'gray', 'red', 'orange', 'cyan'.
 * @returns {string} - El texto envuelto con formato de color.
 * @throws {Error} - Se lanza un error si el tipo de color no es válido.
 * 
 * @example
 * const resultado = colorWrapper('Texto en rojo', 'red');
 * console.log(resultado); // Output: "<fc=#e06c75>Texto en rojo</fc>"
 * 
 * @example
 * // Si el tipo de color no es válido, se lanza un error
 * try {
 *   const resultadoInvalido = colorWrapper('Texto', 'invalido');
 * } catch (error) {
 *   console.error(error.message); // Output: "Tipo de color no válido. Use 'white', 'gray', 'red', 'orange' o 'cyan'."
 * }
 */
const colorWrapper = (children, type) => {
  let color;

  switch(type) {
    case 'white':
      color = '#ffffff';
      break;

    case 'gray':
      color = '#abb2bf';
      break;

    case 'red':
      color = '#e06c75';
      break;

    case 'orange':
      color = '#d19a66';
      break;

    case 'cyan':
      color = '#61aeee';
      break;

    default:
      throw new Error("Tipo de color no válido. Use 'white', 'gray', 'red', 'orange' o 'cyan'.");
  }

  return `<fc=${color}>${children}</fc>`;
};
/* ================================ */

/**
 * Verifica el flag pasado al script
 * @param {string[]} args Recibe un array con los posibles flags para el script
 * @returns {boolean|Object} Retorna true si el flag pasado existe dentro del script
 * @example
 * // Ejemplo de uso:
 * const flagsPresent = checkArg(['--battery', '-b']);
 * console.log(flagsPresent); // Output: true
 * */
const checkArg = (args) => {
  const flags = process.argv.slice(3);

  if (flags.length === 1) {
    const flag = flags[0];
    const regex = new RegExp(`(${args.join('|')})$`, 'i');

    return regex.test(flag);
  }

  // verificar si flags.length > 1 => retornar un objeto { languaje: 'us' }

}

/**
 * Recibe un string y lo corta desde el final con el índice pasado.
 * @param {string} str - El string original.
 * @param {number} index - El índice desde el final para cortar el string.
 * @returns {string} - El string resultante después de cortarlo desde el índice indicado.
 */
const trimStrings = (str, index) => str.substring(str.length - index).trim();

/**
 * Obtiene el código del idioma actual configurado en el teclado.
 * @returns {Promise<string>} El código del idioma actual del teclado ('us' para inglés, 'es' para español).
 */
const getLanguajeLayout = async () => {
  const { stdout: layout } = await $`setxkbmap -query | grep layout`;
  const currentLayout = trimStrings(layout, 3);

  return currentLayout
}

/**
 * Obtiene el idioma actual del teclado y lo cambia por 'us' si es español, o 'es' si es inglés.
 * @returns {Promise<string>} - El código de idioma al que se cambió ('us' o 'es').
 */
const changeLanguaje = async () => {
  const currentLayout = await getLanguajeLayout();
  const lan = currentLayout === 'es' ? 'us' : 'es';

  await $`setxkbmap ${lan}`;
  await $`dunstify "" -u low -t 1500 -i ~/dotfiles/icons/fontawesome/lan-${lan}.svg -r 100818`;

  return lan
}

/**
 * Obtiene el porcentaje de la batería del teclado.
 *
 * @async
 * @function
 * @returns {Promise<string>} Porcentaje de la batería del teclado.
 * @throws {Error} Si hay un error al obtener el porcentaje de la batería.
 * @example
 * const batteryPercentage = await getPercentageBattery();
 * console.log(batteryPercentage); // "80%"
 */
const getPercentageBattery = async () => {
  try {
    const { stdout: line } = await $`upower '--dump' | grep -ie 'keyboard' -A 5 | tail -n1`;
    const percentage = line.substring(line.length - 5).trim();

    return percentage;
  } catch (e) {
    return '';
  }
}

if (checkArg(['--battery', '-b'])) {
  const battery = await getPercentageBattery();
  const batteryOutput = battery ? ` (${battery})` : '';

  echo(batteryOutput);
}

if (checkArg(['--change', '-c'])) {
  await changeLanguaje();
}

if (checkArg(['--xmobar'])) {
  // layout
  const lan = (await getLanguajeLayout()).toUpperCase()
  const lanOutput = lan === 'US' ? colorWrapper(lan, 'gray') : colorWrapper(lan, 'red');

  // icono
  const icon = fontWrapper('', 6);
  const iconOutput = lan === 'US' ? colorWrapper(icon, 'gray') : colorWrapper(icon, 'red');

  echo(`${iconOutput} ${lanOutput}`);
}
