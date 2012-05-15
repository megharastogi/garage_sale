$(document).ready(function() {
$('#featured_item_bidding_1').click(function() {

    if($(this).is(':checked'))  {

    $('#price_div').show();

    } else {

    $('#price_div').hide();
    }
});

$('#featured_item_bidding_0').click(function() {

    if($(this).is(':checked'))  {

    $('#price_div').hide();

    } else {

    $('#price_div').show();
    }
});

$('a.tips2').cluetip({
width: 150,    
splitTitle: '|', 
showTitle: true, 
cluetipClass: 'jtip2', 
dropShadow: false,
activation: 'hover',
clickThrough: true});

});



