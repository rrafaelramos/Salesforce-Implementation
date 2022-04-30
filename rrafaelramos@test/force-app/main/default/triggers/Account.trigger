/**
 * @author rrafaelramos
 */
trigger Account on Account ( before insert, before update ) {

    new AccountTH().run();

}