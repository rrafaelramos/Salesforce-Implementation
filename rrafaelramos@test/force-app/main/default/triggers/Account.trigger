/**
 * @author rrafaelramos
 */
trigger Account on Account ( before insert, before update, after insert) {

    new AccountTH().run();

}