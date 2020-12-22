/* eslint no-console:0 */
// https://stackoverflow.com/questions/61755999/uncaught-referenceerror-regeneratorruntime-is-not-defined-in-react
import regeneratorRuntime from "regenerator-runtime";

// RailsUjs is *required* for links in Lucky that use DELETE, POST and PUT.
import Rails from "@rails/ujs";

// Turbolinks is optional. Learn more: https://github.com/turbolinks/turbolinks/
import Turbolinks from "turbolinks";

import ApexCharts from "apexcharts";

import './components/tabs.js';
import './components/notifications.js';
import './components/charts.js';

Rails.start();
Turbolinks.start();
