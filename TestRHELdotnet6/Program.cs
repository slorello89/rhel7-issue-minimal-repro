using System.Net.Security;
using System.Security.Authentication;
using StackExchange.Redis;

var options = new ConfigurationOptions();
options.EndPoints.Add("your_endpoint");
options.Ssl = true;
options.Password = "your_password";
// options.SslProtocols = SslProtocols.Tls12;

options.CertificateValidation += (sender, certificate, chain, errors) =>
{
    Console.WriteLine(errors);
    return true;
};

var muxer = ConnectionMultiplexer.Connect(options);
var db = muxer.GetDatabase();

db.StringSet("foo", "bar");
Console.WriteLine("Completed. . .");