defineClass('JPViewController', {
            handleBtn: function(sender) {
            require('UINavigationBar').appearance().setBackgroundImage_forBarMetrics(null, 0);
            var tableViewCtrl = JPTableViewController.alloc().init()
            self.navigationController().pushViewController_animated(tableViewCtrl, YES)
            }
            })

defineClass('JPTableViewController : UITableViewController <UIAlertViewDelegate>', {
            dataSource: function() {
            
            var data = self.getProp('data')
            if (data) return data;
            var data = [];
            for (var i = 0; i < 20; i ++) {
            data.push("cell from js " + i);
            }
            self.setProp_forKey(data, 'data')
            return data;
            },
            
            
            
            viewDidLoad: function() {
            
            self.super().viewDidLoad();
            
            
            require('UIColor');
            
//            self.tableView().setBackgroundColor(UIColor.redColor());
            
            self.setTitle("Name");
            
            console.log('viewDidLoad')
            
            },
            

            
            viewWillAppear: function(animated) {
            
            self.super().viewWillAppear(animated);
            
            console.log('viewWillAppear')
            
            },
            //MARK:tableviewDatasource
            numberOfSectionsInTableView: function(tableView) {
            return 1;
            },
            tableView_numberOfRowsInSection: function(tableView, section) {
            return self.dataSource().count();
            },
            tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
            var cell = tableView.dequeueReusableCellWithIdentifier("cell")
            if (!cell) {
            cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
            }
            cell.textLabel().setText(self.dataSource().objectAtIndex(indexPath.row()))
            return cell
            },
            
            tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
            return 80
            },
            tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert",self.dataSource().objectAtIndex(indexPath.row()), self, "OK", null);
            alertView.show()
            },
            
            tableView_commitEditingStyle_forRowAtIndexPath: function(tableView, editingStyle, indexPath) {
            
            if (editingStyle == 1) {// 1 表示枚举 UITableViewCellEditingStyleDelete
            
            self.dataSource().removeObjectAtIndex(indexPath.row());
            console.log('click btn ')
            // 0 表示枚举 UITableViewRowAnimationFade
            tableView.deleteRowsAtIndexPaths_withRowAnimation([indexPath], 0);
            
            }
            },
            tableView_titleForDeleteConfirmationButtonForRowAtIndexPath: function(tableView, indexPath) {
            return "删除";
            },
            
            alertView_willDismissWithButtonIndex: function(alertView, idx) {
            console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
            }
            })