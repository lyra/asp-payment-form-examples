# Lyra ASP payment example

The code presented here is an example of the implementation of the Lyra payment gateway form API in classic ASP technology. It aims to ease its use and learning.

## Contents

This project main contents are:

* `form.asp`: A centralized configuration and initialization file, it implements the V2 payment form.
* `return.asp`: The file for the return URL at the end of the payment.
* `lyra_api.asp`: A core file that contains the Lyra payment API logic. It contains the functions used by the payment script (including the SHA encryption functions).
* Some other resources for styling pages and payment card logos.

## Usage

Copy the content of this project to your ASP server web directory (wwwroot for IIS). Load the `form.asp` page from your favorite browser using the server URL. Please read comments inside the code files and make the described changes if necessary.

## License

Each source file included in this distribution is licensed under the GNU General Public License (GPL 3.0 or later).

Please see LICENSE.txt for the full text of the GPL 3.0 license. It is also available through the world-wide-web at this URL: http://www.gnu.org/licenses/gpl.html.
