/**
 * Copyright (c) 2015 SONATA-NFV [, ANY ADDITIONAL AFFILIATION]
 * ALL RIGHTS RESERVED.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     https://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * Neither the name of the SONATA-NFV [, ANY ADDITIONAL AFFILIATION]
 * nor the names of its contributors may be used to endorse or promote 
 * products derived from this software without specific prior written 
 * permission.
 * 
 * This work has been performed in the framework of the SONATA project,
 * funded by the European Commission under Grant number 671517 through 
 * the Horizon 2020 and 5G-PPP programmes. The authors would like to 
 * acknowledge the contributions of their colleagues of the SONATA 
 * partner consortium (www.sonata-nfv.eu).* dirPagination - AngularJS module for paginating (almost) anything.
 */

 describe('SonataBSS User Management.', function() {

    describe('Register View:', function(){
    
        beforeEach(function() {
            browser.driver.manage().window().maximize();                
            browser.get('https://'+browser.params.host+':'+browser.params.port);
        });
        
        it('title must be SonataBSS', function() {
            expect(browser.getTitle()).toEqual('SonataBSS');
        });

        it('redirection to login page', function() {        
            expect(browser.getCurrentUrl()).toBe('https://'+browser.params.host+':'+browser.params.port+'/#/login');
        });       

        it('registration successful', function() {            
            browser.driver.findElement(by.xpath('//a[. = "Register"]')).click();
            expect(browser.getCurrentUrl()).toBe('https://'+browser.params.host+':'+browser.params.port+'/#/register');
            browser.driver.findElement(by.id('firstName')).sendKeys('sonata');
            browser.driver.findElement(by.id('lastName')).sendKeys('sonata');
            browser.driver.findElement(by.id('username')).sendKeys('sonata');
            browser.driver.findElement(by.id('password')).sendKeys('sonata');
            browser.driver.findElement(by.id('userEmail')).sendKeys('sonata@mail.com');
            browser.driver.findElement(by.xpath('//button[. = "Register"]')).click();            
            modal = element(by.id('success'));
            expect(modal.isDisplayed()).toBe(true);
            expect(browser.getCurrentUrl()).toBe('https://'+browser.params.host+':'+browser.params.port+'/#/login');
        });
    });

    describe('Login View:', function(){
    
        beforeEach(function() {
            browser.driver.manage().window().maximize();                
            browser.get('https://'+browser.params.host+':'+browser.params.port);
        });
        
        it('title must be SonataBSS', function() {
            expect(browser.getTitle()).toEqual('SonataBSS');
        });

        it('redirection to login page', function() {        
            expect(browser.getCurrentUrl()).toBe('https://'+browser.params.host+':'+browser.params.port+'/#/login');
        });        

        it('login successful; redirection to NSDs page', function() {            
            browser.driver.findElement(by.id('username')).sendKeys('sonata');
            browser.driver.findElement(by.id('password')).sendKeys('sonata');
            browser.driver.findElement(by.xpath('//button[. = "Login"]')).click();
            expect(browser.getCurrentUrl()).toBe('https://'+browser.params.host+':'+browser.params.port+'/#/nSDs');
        });
    });    
});