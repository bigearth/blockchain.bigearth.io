// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
/// <reference path="../definitions/jquery.d.ts" />
/// <reference path="../definitions/lodash.d.ts" />
System.register(["jquery", "lodash"], function(exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var $, _;
    return {
        setters:[
            function ($_1) {
                $ = $_1;
            },
            function (_1) {
                _ = _1;
            }],
        execute: function() {
            window.onload = function () {
                'use strict';
                var Calculator = (function () {
                    function Calculator(exchange_rate) {
                        // accept @exchange_rate argument and set it as an instance var
                        var _this = this;
                        this.exchange_rate = exchange_rate;
                        // event handler for 2 selectors and 2 events
                        $('#btc_calculator_input, #usd_calculator_input').on('change keyup', function (evt) {
                            // determine which type of input has fired
                            var type;
                            if ($(evt.currentTarget).attr('id') === 'btc_calculator_input') {
                                type = 'btc';
                            }
                            else {
                                type = 'usd';
                            }
                            // calculate exchange rate
                            _this.calculate_exchange($(evt.currentTarget).val(), type);
                        });
                        // event handler for radio btns
                        $("#calculator .btn-group .btn").on('click', function (evt) {
                            // determine which btn is selected
                            var type = _.trim($(evt.currentTarget).text().toLowerCase());
                            // update the DOM accordingly
                            if (type === 'btc') {
                                if (!$('#usd_calculator_input').closest('.form-group').hasClass('hide')) {
                                    $('#usd_calculator_input').closest('.form-group').addClass('hide');
                                }
                                if ($('#usd_value').closest('div').hasClass('hide')) {
                                    $('#usd_value').closest('div').removeClass('hide');
                                }
                                if ($('#btc_calculator_input').closest('.form-group').hasClass('hide')) {
                                    $('#btc_calculator_input').closest('.form-group').removeClass('hide');
                                }
                                if (!$('#btc_value').closest('div').hasClass('hide')) {
                                    $('#btc_value').closest('div').addClass('hide');
                                }
                            }
                            else if (type === 'usd') {
                                if ($('#usd_calculator_input').closest('.form-group').hasClass('hide')) {
                                    $('#usd_calculator_input').closest('.form-group').removeClass('hide');
                                }
                                if (!$('#usd_value').closest('div').hasClass('hide')) {
                                    $('#usd_value').closest('div').addClass('hide');
                                }
                                if (!$('#btc_calculator_input').closest('.form-group').hasClass('hide')) {
                                    $('#btc_calculator_input').closest('.form-group').addClass('hide');
                                }
                                if ($('#btc_value').closest('div').hasClass('hide')) {
                                    $('#btc_value').closest('div').removeClass('hide');
                                }
                            }
                        });
                    }
                    Calculator.prototype.calculate_exchange = function (num, type) {
                        //  calculate exchange value depending on which input field has fired
                        var final_rate;
                        if (type === 'btc') {
                            final_rate = this.exchange_rate * num;
                        }
                        else {
                            final_rate = num / this.exchange_rate;
                        }
                        // update the DOM accordingly
                        if (type === 'btc') {
                            $('#btc_value').text(num);
                            $('#usd_value').text(final_rate.toFixed(2).toLocaleString());
                            $('#usd_calculator_input').val(final_rate.toFixed(2).toLocaleString());
                        }
                        else if (type === 'usd') {
                            $('#usd_value').text(num);
                            $('#btc_value').text(final_rate.toFixed(8));
                            $('#btc_calculator_input').val(final_rate.toFixed(8));
                        }
                    };
                    return Calculator;
                }());
                var calculator = new Calculator($('body').data('exchange_rate'));
            };
        }
    }
});
