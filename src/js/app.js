/* eslint no-console:0 */

// RailsUjs is *required* for links in Lucky that use DELETE, POST and PUT.
import Rails from "@rails/ujs";

// Turbolinks is optional. Learn more: https://github.com/turbolinks/turbolinks/
import Turbolinks from "turbolinks";

import ApexCharts from "apexcharts";

import './components/tabs.js';
import './components/notifications.js';

window.ApexCharts = ApexCharts

Rails.start();
Turbolinks.start();
